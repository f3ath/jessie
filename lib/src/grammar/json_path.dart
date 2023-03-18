import 'package:json_path/functions.dart';
import 'package:json_path/src/fun/built_in/count_fun.dart';
import 'package:json_path/src/fun/built_in/length_fun.dart';
import 'package:json_path/src/fun/built_in/match_fun.dart';
import 'package:json_path/src/fun/built_in/search_fun.dart';
import 'package:json_path/src/fun/built_in/value_fun.dart';
import 'package:json_path/src/fun/fun_call.dart';
import 'package:json_path/src/fun/fun_factory.dart';
import 'package:json_path/src/grammar/array_index.dart';
import 'package:json_path/src/grammar/array_slice.dart';
import 'package:json_path/src/grammar/comparison_expression.dart';
import 'package:json_path/src/grammar/dot_name.dart';
import 'package:json_path/src/grammar/field_selector.dart';
import 'package:json_path/src/grammar/filter_selector.dart';
import 'package:json_path/src/grammar/fun_name.dart';
import 'package:json_path/src/grammar/literal.dart';
import 'package:json_path/src/grammar/negatable.dart';
import 'package:json_path/src/grammar/parser_ext.dart';
import 'package:json_path/src/grammar/select_all_recursively.dart';
import 'package:json_path/src/grammar/selector.dart';
import 'package:json_path/src/grammar/sequence_selector.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/grammar/union_selector.dart';
import 'package:json_path/src/grammar/wildcard.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:petitparser/petitparser.dart';

class JsonPathGrammarDefinition extends GrammarDefinition<Expression<Nodes>> {
  JsonPathGrammarDefinition(Iterable<Fun> userFunctions)
      : _fun = FunFactory(userFunctions.followedBy(_builtInFun));

  static const _builtInFun = <Fun>[
    LengthFun(),
    CountFun(),
    MatchFun(),
    SearchFun(),
    ValueFun(),
  ];

  final FunFactory _fun;

  @override
  Parser<Expression<Nodes>> start() => ref0(_absPath).end();

  Parser<Selector> _unionElement() => [
        arraySlice,
        arrayIndex,
        wildcard,
        quotedString.map(fieldSelector),
        ref0(_expressionFilter)
      ].toChoiceParser().trim();

  Parser<Selector> _union() =>
      _unionElement().toList().inBrackets().map(unionSelector);

  Parser<Selector> _recursion() => [
        wildcard,
        _union(),
        memberNameShorthand,
      ]
          .toChoiceParser()
          .skip(before: string('..'))
          .map((value) => sequenceSelector([selectAllRecursively, value]));

  Parser<Expression<bool>> _parenExpr() => negatable(
        _logicalExpr().inParens(),
      );

  Parser<Expression> _funArgument() => [
        literal,
        _filterPath(),
        ref0(_funExpr),
      ].toChoiceParser().trim();

  Parser<T> _funCall<T>(T Function(FunCall) funMaker) =>
      (funName & _funArgument().toList().inParens())
          .map((v) => FunCall(v[0], v[1]))
          .tryMap(funMaker);

  Parser<Expression> _funExpr() => _funCall(_fun.any);

  Parser<Expression<Maybe>> _comparableFunExpr() => _funCall(_fun.comparable);

  Parser<Expression<bool>> _logicalFunExpr() => _funCall(_fun.logical);

  Parser<Expression<Maybe>> _comparable() => [
        literal,
        ref0(_filterPath).map((expr) => expr.map((v) => v.asValue)),
        _comparableFunExpr(),
      ].toChoiceParser();

  Parser<Expression<bool>> _logicalExpr() => _logicalOrExpr();

  Parser<Expression<bool>> _logicalOrExpr() => _logicalOrSequence()
      .map((list) => list.reduce((a, b) => a.merge(b, (a, b) => a || b)));

  Parser<List<Expression<bool>>> _logicalOrSequence() =>
      _logicalAndExpr().toList(string('||'));

  Parser<Expression<bool>> _logicalAndExpr() => _logicalAndSequence()
      .map((list) => list.reduce((a, b) => a.merge(b, (a, b) => a && b)));

  Parser<List<Expression<bool>>> _logicalAndSequence() =>
      _basicExpr().toList(string('&&'));

  Parser<Expression<bool>> _basicExpr() => [
        ref0(_parenExpr),
        comparisonExpression(_comparable()),
        _testExpr(),
      ].toChoiceParser();

  Parser<Expression<Nodes>> _filterPath() => [
        ref0(_relPath),
        ref0(_absPath),
      ].toChoiceParser();

  Parser<Expression<bool>> _existenceTest() =>
      ref0(_filterPath).map((value) => value.map((v) => v.asLogical));

  Parser<Expression<bool>> _testExpr() => negatable([
        _existenceTest(),
        _logicalFunExpr(),
      ].toChoiceParser());

  Parser<Selector> _expressionFilter() =>
      _logicalExpr().skip(before: string('?')).map(filterSelector);

  Parser<Selector> _segment() => [
        dotName,
        ref0(_union),
        ref0(_recursion),
      ].toChoiceParser();

  Parser<Expression<Nodes>> _segmentSequence() =>
      _segment().star().map(sequenceSelector).map(Expression.new);

  Parser<Expression<Nodes>> _absPath() => _segmentSequence()
      .skip(before: char(r'$'))
      .map((expr) => Expression((node) => expr.apply(node.root)));

  Parser<Expression<Nodes>> _relPath() =>
      _segmentSequence().skip(before: char('@'));
}
