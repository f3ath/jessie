import 'package:json_path/json_path.dart';
import 'package:json_path/src/expression_function/fun_call.dart';
import 'package:json_path/src/expression_function/types.dart';
import 'package:json_path/src/grammar/array_index.dart';
import 'package:json_path/src/grammar/array_slice.dart';
import 'package:json_path/src/grammar/dot_name.dart';
import 'package:json_path/src/grammar/function_name.dart';
import 'package:json_path/src/grammar/literal.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/grammar/wildcard.dart';
import 'package:json_path/src/parser_ext.dart';
import 'package:json_path/src/selectors.dart';
import 'package:json_path/src/types/node_mapper.dart';
import 'package:json_path/src/types/node_selector.dart';
import 'package:json_path/src/types/node_test.dart';
import 'package:petitparser/petitparser.dart';

class JsonPathGrammarDefinition extends GrammarDefinition<NodeSelector> {
  JsonPathGrammarDefinition({Algebra? algebra})
      : _algebra = algebra ?? Algebra();

  final Algebra _algebra;

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

  Parser<NodeTest> _parenExpr() => ref1(
        _negatable,
        ref0(_logicalExpr)
            .skip(before: char('(').trim(), after: char(')').trim()),
      );

  Parser<NodeTest> _negation(Parser<NodeTest> p) => p
      .skip(before: char('!').trim())
      .map((mapper) => (node) => mapper(node).not());

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

  Parser<NodeMapper> _funExpr() => (functionName &
              _functionArguments().skip(before: char('('), after: char(')')))
          .map((v) => FunCall(v[0], v[1]))
          .tryMap((call) {
        return _algebra.makeFun(call);
      });

  Parser<NodeTest> _testFunExpr() => (functionName &
              _functionArguments().skip(before: char('('), after: char(')')))
          .map((v) => FunCall(v[0], v[1]))
          .tryMap((call) {
        return _algebra.makeTestFun(call);
      });

  Parser<NodeMapper> _comparable() => [
        literal.toNodeMapper(),
        ref0(_relPath),
        ref0(_funExpr),
      ].toChoiceParser();

  static final _cmpOp =
      ['==', '!=', '<=', '>=', '<', '>'].map(string).toChoiceParser().trim();

  Parser<NodeTest> _cmpExpr() =>
      (ref0(_comparable) & _cmpOp & ref0(_comparable)).map((v) {
        final left = v[0];
        final op = v[1];
        final right = v[2];
        return (node) => _algebra.test(op, left(node), right(node));
      });

  Parser<NodeTest> _logicalExpr() => ref0(_logicalOrExpr);

  Parser<NodeTest> _logicalOrExpr() => [
        ref0(_logicalAndExpr).map((v) => [v]),
        ref0(_logicalAndExpr).skip(before: string('||').trim()).star(),
      ].toSequenceParser().map((v) => v.expand((e) => e)).map((tests) =>
          (node) => LogicalType(tests.any((test) => test(node).asBool)));

  Parser<NodeTest> _logicalAndExpr() => [
        ref0(_basicExpr).map((v) => [v]),
        ref0(_basicExpr).skip(before: string('&&').trim()).star(),
      ].toSequenceParser().map((v) => v.expand((e) => e)).map((tests) =>
          (node) => LogicalType(tests.every((test) => test(node).asBool)));

  Parser<NodeTest> _negatable(Parser<NodeTest> p) =>
      [ref1(_negation, p), p].toChoiceParser();

  Parser<NodeTest> _basicExpr() => [
        ref0(_parenExpr),
        ref0(_cmpExpr),
        ref0(_testExpr),
      ].toChoiceParser();

  Parser<NodeMapper<Nodes>> _filterPath() => [
        ref0(_relPath),
        ref0(_absPath),
      ].toChoiceParser();

  Parser<NodeTest> _existenceTest() =>
      ref0(_filterPath).map((selector) => (node) => selector(node).asLogical);

  Parser<NodeTest> _testExpr() => ref1(
      _negatable,
      [
        ref0(_existenceTest),
        ref0(_testFunExpr),
      ].toChoiceParser());

  Parser<NodeSelector> _expressionFilter() =>
      ref0(_logicalExpr).skip(before: string('?')).map(testSelector);

  Parser<NodeSelector> _segment() => [
        dotName,
        ref0(_union),
        ref0(_recursion),
      ].toChoiceParser();

  Parser<NodeMapper<Nodes>> _segmentSequence() => ref0(_segment)
      .star()
      .map(sequenceSelector)
      .map((selector) => (node) => Nodes(selector(node)));

  Parser<NodeMapper<Nodes>> _absPath() =>
      ref0(_segmentSequence).skip(before: char(r'$'));

  Parser<NodeMapper<Nodes>> _relPath() =>
      ref0(_segmentSequence).skip(before: char('@'));
}

final jsonPath = JsonPathGrammarDefinition().build<NodeSelector>();
