import 'package:json_path/json_path.dart';
import 'package:json_path/src/expression_function/function_call.dart';
import 'package:json_path/src/grammar/array_index.dart';
import 'package:json_path/src/grammar/array_slice.dart';
import 'package:json_path/src/grammar/dot_matcher.dart';
import 'package:json_path/src/grammar/expression/literal.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/grammar/wildcard.dart';
import 'package:json_path/src/parser_ext.dart';
import 'package:json_path/src/selector.dart';
import 'package:json_path/src/selector/expression_filter.dart';
import 'package:json_path/src/selector/field.dart';
import 'package:json_path/src/selector/recursion.dart';
import 'package:json_path/src/selector/sequence.dart';
import 'package:json_path/src/selector/union.dart';
import 'package:petitparser/petitparser.dart';

class JsonPathGrammarDefinition extends GrammarDefinition<Selector> {
  JsonPathGrammarDefinition({Algebra algebra = const Algebra()})
      : _algebra = algebra;

  final Algebra _algebra;

  @override
  Parser<Selector> start() => ref0(_jsonPath).end();

  Parser<Selector> _unionElement() => [
        arraySlice,
        arrayIndex,
        wildcard,
        quotedString.map(Field.new),
        ref0(_expressionFilter),
      ].toChoiceParser().trim();

  Parser<Selector> _nextUnionElement() =>
      ref0(_unionElement).skip(before: char(','));

  Parser<Iterable<Selector>> _unionContent() =>
      (ref0(_unionElement) & ref0(_nextUnionElement).star())
          .map((value) => [value.first as Selector].followedBy((value.last)));

  Parser<Selector> _union() => ref0(_unionContent)
      .skip(before: char('['), after: char(']'))
      .map(Union.new);

  Parser<Selector> _recursion() => [
        wildcard,
        ref0(_union),
        memberNameShorthand,
      ]
          .toChoiceParser()
          .skip(before: string('..'))
          .map((value) => Sequence([const Recursion(), value]));

  Parser<NodeMapper<bool>> _parenExpr() => ref1(
        _negatable,
        ref0(_logicalExpr)
            .skip(before: char('(').trim(), after: char(')').trim()),
      );

  Parser<NodeMapper<bool>> _negation(Parser p) => p
      .skip(before: char('!').trim())
      .map((mapper) => (node) => !_algebra.isTruthy(mapper(node)));

  Parser _functionArgument() => [
        literal,
        ref0(_filterPath),
      ].toChoiceParser().trim();

  Parser _functionNextArgument() =>
      _functionArgument().skip(before: char(',').trim()).trim();

  Parser<List> _functionArguments() =>
      (_functionArgument() & _functionNextArgument().star())
          .map((value) => [value.first, ...value[1]]);

  final _functionNameFirst = lowercase();
  final _functionNameChar = [
    char('_'),
    digit(),
    lowercase(),
  ].toChoiceParser();

  Parser<String> _functionName() =>
      (_functionNameFirst & _functionNameChar.star()).flatten();

  Parser<NodeMapper> _functionExpr() => (_functionName() &
              _functionArguments().skip(before: char('('), after: char(')')))
          .map((value) => FunctionCall(value[0], value[1]))
          .where((call) {
        // TODO: refactor
        try {
          _algebra.makeFunction(call);
          return true;
        } on FormatException {
          return false;
        }
      }).map((call) {
        return _algebra.makeFunction(call);
      });

  Parser<NodeMapper<bool>> _predicateFunctionExpr() => (_functionName() &
          _functionArguments().skip(before: char('('), after: char(')')))
      .map((value) => FunctionCall(value[0], value[1]))
      .map((call) => _algebra.makePredicateFunction(call))
      .map((fun) => (node) => fun(node).asBool);

  Parser _comparable() => [
        literal.toNodeMapper(),
        ref0(_relPath),
        ref0(_functionExpr),
      ].toChoiceParser();

  static const _eq = '==';
  static const _ne = '!=';
  static const _le = '<=';
  static const _ge = '>=';
  static const _lt = '<';
  static const _gt = '>';

  static final _comparisonOp = [
    string(_eq),
    string(_ne),
    string(_le),
    string(_ge),
    string(_lt),
    string(_gt),
  ].toChoiceParser();

  Parser<NodeMapper<bool>> _comparisonExpr() =>
      (ref0(_comparable) & _comparisonOp.trim() & ref0(_comparable)).map((v) {
        final left = v[0];
        final right = v[2];
        final operations = <String, bool Function(dynamic, dynamic)>{
          _eq: _algebra.eq,
          _ne: _algebra.ne,
          _le: _algebra.le,
          _ge: _algebra.ge,
          _lt: _algebra.lt,
          _gt: _algebra.gt,
        };
        final op = operations[v[1]] ?? (throw StateError('Invalid op'));
        return (Node node) => op(left(node), right(node));
      });

  Parser<NodeMapper<bool>> _logicalExpr() => ref0(_logicalOrExpr);

  Parser<NodeMapper<bool>> _logicalOrExpr() => (ref0(_logicalAndExpr) &
          ref0(_logicalAndExpr).skip(before: string('||').trim()).star())
      .map((value) => [value.first].followedBy(value.last ?? []))
      .map<NodeMapper<bool>>((value) =>
          (node) => value.any((expr) => _algebra.isTruthy(expr(node))));

  Parser<NodeMapper<bool>> _logicalAndExpr() => (ref0(_basicExpr) &
          ref0(_basicExpr).skip(before: string('&&').trim()).star())
      .map((value) => [value.first].followedBy(value.last ?? []))
      .map<NodeMapper<bool>>((value) =>
          (node) => value.every((expr) => _algebra.isTruthy(expr(node))));

  Parser<NodeMapper<bool>> _negatable(Parser<NodeMapper<bool>> p) =>
      [ref1(_negation, p), p].toChoiceParser();

  Parser<NodeMapper<bool>> _basicExpr() => [
        ref0(_parenExpr),
        ref0(_comparisonExpr),
        ref0(_testExpr),
      ].toChoiceParser();

  Parser _filterPath() => [
        ref0(_relPath),
        ref0(_jsonPath),
      ].toChoiceParser();

  Parser<NodeMapper<bool>> _filterPathBool() => [
        ref0(_relPath)
            .map((value) => (node) => _algebra.isTruthy(value(node))),
        ref0(_jsonPath)
            .map((value) => (node) => _algebra.isTruthy(value.apply(node))),
      ].toChoiceParser();

  Parser<NodeMapper<bool>> _testExpr() => ref1(
      _negatable,
      [
        ref0(_filterPathBool),
        ref0(_predicateFunctionExpr),
      ].toChoiceParser());

  Parser<Selector> _expressionFilter() =>
      ref0(_logicalExpr).skip(before: string('?')).map((ExpressionFilter.new));

  Parser<Selector> _segment() => [
        dotMatcher,
        ref0(_union),
        ref0(_recursion),
      ].toChoiceParser();

  Parser<Selector> _segmentSequence() =>
      ref0(_segment).star().map(Sequence.new);

  Parser<Selector> _jsonPath() =>
      ref0(_segmentSequence).skip(before: char(r'$'));

  Parser<NodeMapper<Iterable<Node>>> _relPath() => ref0(_segmentSequence)
      .skip(before: char('@'))
      .map((sequence) => (node) => [node].expand(sequence.apply));
}

final jsonPath = JsonPathGrammarDefinition().build<Selector>();
