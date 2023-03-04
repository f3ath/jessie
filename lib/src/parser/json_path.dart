import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/fun/fun_call.dart';
import 'package:json_path/src/fun/fun_repository.dart';
import 'package:json_path/src/fun/standard_functions.dart';
import 'package:json_path/src/fun/types/bool_expression.dart';
import 'package:json_path/src/fun/types/nodes.dart';
import 'package:json_path/src/fun/types/nodes_expression.dart';
import 'package:json_path/src/fun/types/value_expression.dart';
import 'package:json_path/src/node_mapper.dart';
import 'package:json_path/src/parser/array_index.dart';
import 'package:json_path/src/parser/array_slice.dart';
import 'package:json_path/src/parser/cmp_operator.dart';
import 'package:json_path/src/parser/compare.dart';
import 'package:json_path/src/parser/dot_name.dart';
import 'package:json_path/src/parser/fun_name.dart';
import 'package:json_path/src/parser/literal.dart';
import 'package:json_path/src/parser/parser_ext.dart';
import 'package:json_path/src/parser/strings.dart';
import 'package:json_path/src/parser/types.dart';
import 'package:json_path/src/parser/wildcard.dart';
import 'package:json_path/src/selectors.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:petitparser/petitparser.dart';

class JsonPathGrammarDefinition extends GrammarDefinition<NodesExpression> {
  JsonPathGrammarDefinition(Iterable<Fun> functions)
      : _fun = FunRepository(functions);

  final FunRepository _fun;

  @override
  Parser<NodesExpression> start() => ref0(_absPath).end();

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

  Parser<BoolExpression> _parenExpr() => ref1(
        _negatable,
        ref0(_logicalExpr)
            .skip(before: char('(').trim(), after: char(')').trim()),
      );

  Parser<BoolExpression> _negation(Parser<BoolExpression> p) =>
      p.skip(before: char('!').trim()).map((mapper) => mapper.map((v) => !v));

  Parser<NodeMapper> _funArgument() => [
        literal,
        ref0(_filterPath),
      ].toChoiceParser().trim();

  Parser<NodeMapper> _funNextArgument() =>
      _funArgument().skip(before: char(',').trim()).trim();

  Parser<List<NodeMapper>> _functionArguments() => [
        _funArgument().map((v) => [v]),
        _funNextArgument().star()
      ].toSequenceParser().map((v) => v.expand((e) => e).toList());

  Parser<T> _funCall<T>(T? Function(FunCall) funMaker) =>
      (funName & _functionArguments().skip(before: char('('), after: char(')')))
          .map((v) => FunCall(v[0], v[1]))
          .tryMap((call) =>
              funMaker(call) ??
              (throw Exception('No implementation for $call found')));

  Parser<ValueExpression> _comparableFunExpr() =>
      ref1(_funCall, _fun.comparable);

  Parser<BoolExpression> _logicalFunExpr() => ref1(_funCall, _fun.logical);

  Parser<ValueExpression> _comparable() => [
        literal,
        ref0(_filterPath).map((it) => it.asValueExpression),
        ref0(_comparableFunExpr),
      ].toChoiceParser();

  Parser<BoolExpression> _cmpExpr() =>
      (ref0(_comparable) & cmpOperator & ref0(_comparable)).map((v) {
        final NodeMapper<Maybe> left = v[0];
        final String op = v[1];
        final NodeMapper<Maybe> right = v[2];

        return left.flatMap(right, (l, r) => compare(op, l, r));
      });

  Parser<BoolExpression> _logicalExpr() => ref0(_logicalOrExpr);

  Parser<BoolExpression> _logicalOrExpr() => [
        ref0(_logicalAndExpr).map((v) => [v]),
        ref0(_logicalAndExpr).skip(before: string('||').trim()).star(),
      ].toSequenceParser().map((v) => v.expand((e) => e)).map(
          (tests) => tests.reduce((a, b) => a.flatMap(b, (a, b) => a || b)));

  Parser<BoolExpression> _logicalAndExpr() => [
        ref0(_basicExpr).map((v) => [v]),
        ref0(_basicExpr).skip(before: string('&&').trim()).star(),
      ].toSequenceParser().map((v) => v.expand((e) => e)).map(
          (tests) => tests.reduce((a, b) => a.flatMap(b, (a, b) => a && b)));

  Parser<BoolExpression> _negatable(Parser<BoolExpression> p) =>
      [ref1(_negation, p), p].toChoiceParser();

  Parser<BoolExpression> _basicExpr() => [
        ref0(_parenExpr),
        ref0(_cmpExpr),
        ref0(_testExpr),
      ].toChoiceParser();

  Parser<NodesExpression> _filterPath() => [
        ref0(_relPath),
        ref0(_absPath),
      ].toChoiceParser();

  Parser<BoolExpression> _existenceTest() =>
      ref0(_filterPath).map((value) => value.asLogicalExpression);

  Parser<BoolExpression> _testExpr() => ref1(
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

  Parser<NodesExpression> _segmentSequence() => ref0(_segment)
      .star()
      .map(sequenceSelector)
      .map((selector) => NodeMapper((node) => Nodes(selector(node))));

  Parser<NodesExpression> _absPath() => ref0(_segmentSequence)
      .skip(before: char(r'$'))
      .map((value) => NodeMapper((node) => value.applyTo(node.root)));

  Parser<NodesExpression> _relPath() =>
      ref0(_segmentSequence).skip(before: char('@'));
}
