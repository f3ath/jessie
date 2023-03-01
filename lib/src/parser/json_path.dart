import 'package:json_path/src/fun/fun_call.dart';
import 'package:json_path/src/fun/fun_repository.dart';
import 'package:json_path/src/fun/types/logical_expression.dart';
import 'package:json_path/src/fun/types/nodes.dart';
import 'package:json_path/src/fun/types/nodes_expression.dart';
import 'package:json_path/src/fun/types/value.dart';
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
import 'package:petitparser/petitparser.dart';

class JsonPathGrammarDefinition extends GrammarDefinition<NodesExpression> {
  JsonPathGrammarDefinition();

  final _fun = FunRepository();

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

  Parser<LogicalExpression> _parenExpr() => ref1(
        _negatable,
        ref0(_logicalExpr)
            .skip(before: char('(').trim(), after: char(')').trim()),
      );

  Parser<LogicalExpression> _negation(Parser<LogicalExpression> p) => p
      .skip(before: char('!').trim())
      .map((mapper) => mapper.map((v) => v.not()));

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

  Parser<T> _funCall<T>(T Function(FunCall) funMaker) =>
      (funName & _functionArguments().skip(before: char('('), after: char(')')))
          .map((v) => FunCall(v[0], v[1]))
          .tryMap(funMaker);

  Parser<ValueExpression> _comparableFunExpr() =>
      ref1(_funCall, _fun.makeComparableFun);

  Parser<LogicalExpression> _logicalFunExpr() =>
      ref1(_funCall, _fun.makeLogicalFun);

  Parser<ValueExpression> _comparable() => [
        literal,
        ref0(_relPath).map((it) => it.asValueExpression),
        ref0(_comparableFunExpr),
      ].toChoiceParser();

  Parser<LogicalExpression> _cmpExpr() =>
      (ref0(_comparable) & cmpOperator & ref0(_comparable)).map((v) {
        final NodeMapper<Value> left = v[0];
        final String op = v[1];
        final NodeMapper<Value> right = v[2];

        return left.flatMap(right, (l, r) => compare(op, l, r));
      });

  Parser<LogicalExpression> _logicalExpr() => ref0(_logicalOrExpr);

  Parser<LogicalExpression> _logicalOrExpr() => [
        ref0(_logicalAndExpr).map((v) => [v]),
        ref0(_logicalAndExpr).skip(before: string('||').trim()).star(),
      ].toSequenceParser().map((v) => v.expand((e) => e)).map(
          (tests) => tests.reduce((a, b) => a.flatMap(b, (a, b) => a.or(b))));

  Parser<LogicalExpression> _logicalAndExpr() => [
        ref0(_basicExpr).map((v) => [v]),
        ref0(_basicExpr).skip(before: string('&&').trim()).star(),
      ].toSequenceParser().map((v) => v.expand((e) => e)).map(
          (tests) => tests.reduce((a, b) => a.flatMap(b, (a, b) => a.and(b))));

  Parser<LogicalExpression> _negatable(Parser<LogicalExpression> p) =>
      [ref1(_negation, p), p].toChoiceParser();

  Parser<LogicalExpression> _basicExpr() => [
        ref0(_parenExpr),
        ref0(_cmpExpr),
        ref0(_testExpr),
      ].toChoiceParser();

  Parser<NodesExpression> _filterPath() => [
        ref0(_relPath),
        ref0(_absPath),
      ].toChoiceParser();

  Parser<LogicalExpression> _existenceTest() =>
      ref0(_filterPath).map((value) => value.asLogicalExpression);

  Parser<LogicalExpression> _testExpr() => ref1(
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

  Parser<NodesExpression> _absPath() =>
      ref0(_segmentSequence).skip(before: char(r'$'));

  Parser<NodesExpression> _relPath() =>
      ref0(_segmentSequence).skip(before: char('@'));
}

Parser<NodesExpression> jsonPathParser() =>
    JsonPathGrammarDefinition().build<NodesExpression>();
