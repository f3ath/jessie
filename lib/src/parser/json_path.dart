import 'package:json_path/src/fun/fun_call.dart';
import 'package:json_path/src/fun/fun_repository.dart';
import 'package:json_path/src/fun/type_system.dart';
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

class JsonPathGrammarDefinition extends GrammarDefinition<NodeSelector> {
  JsonPathGrammarDefinition();

  final _fun = FunRepository();

  @override
  Parser<NodeSelector> start() => ref0(_absPath).end();

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
      .map((mapper) => (node) => LogicalType(!mapper(node).asBool));

  Parser _funArgument() => [
        literal,
        ref0(_filterPath),
      ].toChoiceParser().trim();

  Parser _funNextArgument() =>
      _funArgument().skip(before: char(',').trim()).trim();

  Parser<List> _functionArguments() => [
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
        literal.map(Value.new).toNodeMapper(),
        ref0(_relPath).map(nodesToValue),
        ref0(_comparableFunExpr),
      ].toChoiceParser();

  Parser<LogicalExpression> _cmpExpr() =>
      (ref0(_comparable) & cmpOperator & ref0(_comparable)).map((v) {
        final left = v[0];
        final op = v[1];
        final right = v[2];
        return (node) => compare(op, left(node), right(node));
      });

  Parser<LogicalExpression> _logicalExpr() => ref0(_logicalOrExpr);

  Parser<LogicalExpression> _logicalOrExpr() => [
        ref0(_logicalAndExpr).map((v) => [v]),
        ref0(_logicalAndExpr).skip(before: string('||').trim()).star(),
      ].toSequenceParser().map((v) => v.expand((e) => e)).map((tests) =>
          (node) => LogicalType(tests.any((test) => test(node).asBool)));

  Parser<LogicalExpression> _logicalAndExpr() => [
        ref0(_basicExpr).map((v) => [v]),
        ref0(_basicExpr).skip(before: string('&&').trim()).star(),
      ].toSequenceParser().map((v) => v.expand((e) => e)).map((tests) =>
          (node) => LogicalType(tests.every((test) => test(node).asBool)));

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
      ref0(_filterPath).map((selector) => (node) => selector(node).asLogical);

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
      .map((selector) => (node) => NodesType(selector(node)));

  Parser<NodesExpression> _absPath() =>
      ref0(_segmentSequence).skip(before: char(r'$'));

  Parser<NodesExpression> _relPath() =>
      ref0(_segmentSequence).skip(before: char('@'));
}

Parser<NodeSelector> jsonPathParser() =>
    JsonPathGrammarDefinition().build<NodeSelector>();
