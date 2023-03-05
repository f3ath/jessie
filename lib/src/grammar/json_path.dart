import 'package:json_path/functions.dart';
import 'package:json_path/src/fun/built_in/count_fun.dart';
import 'package:json_path/src/fun/built_in/length_fun.dart';
import 'package:json_path/src/fun/built_in/match_fun.dart';
import 'package:json_path/src/fun/fun_call.dart';
import 'package:json_path/src/fun/fun_factory.dart';
import 'package:json_path/src/fun/search_fun.dart';
import 'package:json_path/src/grammar/array_index.dart';
import 'package:json_path/src/grammar/array_slice.dart';
import 'package:json_path/src/grammar/cmp_operator.dart';
import 'package:json_path/src/grammar/compare.dart';
import 'package:json_path/src/grammar/dot_name.dart';
import 'package:json_path/src/grammar/field_selector.dart';
import 'package:json_path/src/grammar/filter_selector.dart';
import 'package:json_path/src/grammar/fun_name.dart';
import 'package:json_path/src/grammar/literal.dart';
import 'package:json_path/src/grammar/node_selector.dart';
import 'package:json_path/src/grammar/parser_ext.dart';
import 'package:json_path/src/grammar/select_all_recursively.dart';
import 'package:json_path/src/grammar/sequence_selector.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/grammar/union_selector.dart';
import 'package:json_path/src/grammar/wildcard.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:petitparser/petitparser.dart';

class JsonPathGrammarDefinition extends GrammarDefinition<Expression<Nodes>> {
  JsonPathGrammarDefinition(Iterable<Fun> userFunctions)
      : _fun = FunFactory(userFunctions.followedBy(_builtInFunctions));

  static const _builtInFunctions = <Fun>[
    LengthFun(),
    CountFun(),
    MatchFun(),
    SearchFun(),
  ];

  final FunFactory _fun;

  @override
  Parser<Expression<Nodes>> start() => ref0(_absPath).end();

  Parser<NodeSelector> _unionElement() => [
        arraySlice,
        arrayIndex,
        wildcard,
        quotedString.map(fieldSelector),
        ref0(_expressionFilter)
      ].toChoiceParser().trim();

  Parser<NodeSelector> _nextUnionElement() =>
      ref0(_unionElement).skip(before: char(','));

  Parser<Iterable<NodeSelector>> _unionContent() => [
        ref0(_unionElement).map((v) => [v]),
        ref0(_nextUnionElement).star()
      ].toSequenceParser().map((v) => v.expand((e) => e));

  Parser<NodeSelector> _union() => ref0(_unionContent)
      .skip(before: char('['), after: char(']'))
      .map(unionSelector);

  Parser<NodeSelector> _recursion() => [
        wildcard,
        ref0(_union),
        memberNameShorthand,
      ]
          .toChoiceParser()
          .skip(before: string('..'))
          .map((value) => sequenceSelector([selectAllRecursively, value]));

  Parser<Expression<bool>> _parenExpr() => ref1(
        _negatable,
        ref0(_logicalExpr)
            .skip(before: char('(').trim(), after: char(')').trim()),
      );

  Parser<Expression<bool>> _negation(Parser<Expression<bool>> p) =>
      p.skip(before: char('!').trim()).map((expr) => expr.map((v) => !v));

  Parser<Expression> _funArgument() => [
        literal,
        ref0(_filterPath),
      ].toChoiceParser().trim();

  Parser<Expression> _funNextArgument() =>
      _funArgument().skip(before: char(',').trim()).trim();

  Parser<List<Expression>> _functionArguments() => [
        _funArgument().map((v) => [v]),
        _funNextArgument().star()
      ].toSequenceParser().map((v) => v.expand((e) => e).toList());

  Parser<T> _funCall<T>(T? Function(FunCall) funMaker) =>
      (funName & _functionArguments().skip(before: char('('), after: char(')')))
          .map((v) => FunCall(v[0], v[1]))
          .tryMap((call) =>
              funMaker(call) ??
              (throw Exception('No implementation for $call found')));

  Parser<Expression<Maybe>> _comparableFunExpr() =>
      ref1(_funCall, _fun.comparable);

  Parser<Expression<bool>> _logicalFunExpr() => ref1(_funCall, _fun.logical);

  Parser<Expression<Maybe>> _comparable() => [
        literal,
        ref0(_filterPath).map((expr) => expr.map((v) => v.asValue)),
        ref0(_comparableFunExpr),
      ].toChoiceParser();

  Parser<Expression<bool>> _cmpExpr() =>
      (ref0(_comparable) & cmpOperator & ref0(_comparable)).map((v) {
        final Expression<Maybe> left = v[0];
        final String op = v[1];
        final Expression<Maybe> right = v[2];

        return left.merge(right, (l, r) => compare(op, l, r));
      });

  Parser<Expression<bool>> _logicalExpr() => ref0(_logicalOrExpr);

  Parser<Expression<bool>> _logicalOrExpr() => [
        ref0(_logicalAndExpr).map((v) => [v]),
        ref0(_logicalAndExpr).skip(before: string('||').trim()).star(),
      ]
          .toSequenceParser()
          .map((v) => v.expand((e) => e))
          .map((tests) => tests.reduce((a, b) => a.merge(b, (a, b) => a || b)));

  Parser<Expression<bool>> _logicalAndExpr() => [
        ref0(_basicExpr).map((v) => [v]),
        ref0(_basicExpr).skip(before: string('&&').trim()).star(),
      ]
          .toSequenceParser()
          .map((v) => v.expand((e) => e))
          .map((tests) => tests.reduce((a, b) => a.merge(b, (a, b) => a && b)));

  Parser<Expression<bool>> _negatable(Parser<Expression<bool>> p) =>
      [ref1(_negation, p), p].toChoiceParser();

  Parser<Expression<bool>> _basicExpr() => [
        ref0(_parenExpr),
        ref0(_cmpExpr),
        ref0(_testExpr),
      ].toChoiceParser();

  Parser<Expression<Nodes>> _filterPath() => [
        ref0(_relPath),
        ref0(_absPath),
      ].toChoiceParser();

  Parser<Expression<bool>> _existenceTest() =>
      ref0(_filterPath).map((value) => value.map((v) => v.isNotEmpty));

  Parser<Expression<bool>> _testExpr() => ref1(
      _negatable,
      [
        ref0(_existenceTest),
        ref0(_logicalFunExpr),
      ].toChoiceParser());

  Parser<NodeSelector> _expressionFilter() =>
      ref0(_logicalExpr).skip(before: string('?')).map(filterSelector);

  Parser<NodeSelector> _segment() => [
        dotName,
        ref0(_union),
        ref0(_recursion),
      ].toChoiceParser();

  Parser<Expression<Nodes>> _segmentSequence() =>
      ref0(_segment).star().map(sequenceSelector).map(Expression.new);

  Parser<Expression<Nodes>> _absPath() => ref0(_segmentSequence)
      .skip(before: char(r'$'))
      .map((expr) => Expression((node) => expr.call(node.root)));

  Parser<Expression<Nodes>> _relPath() =>
      ref0(_segmentSequence).skip(before: char('@'));
}
