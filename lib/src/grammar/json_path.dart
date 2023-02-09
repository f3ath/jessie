import 'package:json_path/json_path.dart';
import 'package:json_path/src/grammar/array_index.dart';
import 'package:json_path/src/grammar/array_slice.dart';
import 'package:json_path/src/grammar/dot_matcher.dart';
import 'package:json_path/src/grammar/expression/callback.dart';
import 'package:json_path/src/grammar/expression/primitive.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/grammar/wildcard.dart';
import 'package:json_path/src/match_mapper.dart';
import 'package:json_path/src/match_set.dart';
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
        callback,
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

  Parser<MatchMapper<bool>> _parenExpr() => ref0(_booleanExpr)
      .skip(before: char('(').trim(), after: char(')').trim());

  Parser<MatchMapper<bool>> _negation(Parser p) => p
      .skip(before: char('!').trim())
      .map((mapper) => (match) => !_algebra.isTruthy(mapper(match)));

  Parser _comparable() => [
        primitive,
        ref0(_relPath),
        ref0(_parenExpr),
      ].toChoiceParser();

  static const _eq = '==';
  static const _ne = '!=';
  static const _le = '<=';
  static const _ge = '>=';
  static const _lt = '<';
  static const _gt = '>';

  static final _comparisonOperation = [
    string(_eq),
    string(_ne),
    string(_le),
    string(_ge),
    string(_lt),
    string(_gt),
  ].toChoiceParser();

  Parser _comparison() =>
      (ref0(_comparable) & _comparisonOperation.trim() & ref0(_comparable))
          .map((v) {
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
        return (JsonPathMatch match) => op(left(match), right(match));
      });

  Parser<MatchMapper<bool>> _booleanExpr() => ref0(_logicalOrExpr);

  Parser<MatchMapper<bool>> _logicalOrExpr() => (ref0(_logicalAndExpr) &
          ref0(_logicalAndExpr).skip(before: string('||').trim()).star())
      .map((value) => [value.first].followedBy(value.last ?? []))
      .map<MatchMapper<bool>>((value) =>
          (match) => value.any((expr) => _algebra.isTruthy(expr(match))));

  Parser<MatchMapper<bool>> _logicalAndExpr() => (ref0(_basicExpr) &
          ref0(_basicExpr).skip(before: string('&&').trim()).star())
      .map((value) => [value.first].followedBy(value.last ?? []))
      .map<MatchMapper<bool>>((value) =>
          (match) => value.every((expr) => _algebra.isTruthy(expr(match))));

  Parser _negatable(Parser p) => [ref1(_negation, p), p].toChoiceParser();

  Parser _basicExpr() => [
        ref0(_comparison),
        ref1(_negatable, ref0(_parenExpr)),
        ref1(_negatable, ref0(_filterPath)),
      ].toChoiceParser();

  Parser _filterPath() => [
        ref0(_relPath),
        ref0(_jsonPath),
        // TODO: add functionExpr
      ].toChoiceParser();

  Parser<Selector> _expressionFilter() =>
      ref0(_booleanExpr).skip(before: string('?')).map((ExpressionFilter.new));

  Parser<Selector> _segment() => [
        dotMatcher,
        ref0(_union),
        ref0(_recursion),
      ].toChoiceParser();

  Parser<Selector> _segmentSequence() =>
      ref0(_segment).star().map(Sequence.new);

  Parser<Selector> _jsonPath() =>
      ref0(_segmentSequence).skip(before: char(r'$'));

  Parser<MatchMapper<MatchSet>> _relPath() =>
      ref0(_segmentSequence).skip(before: char('@')).map<MatchMapper<MatchSet>>(
          (sequence) => (match) => MatchSet([match].expand(sequence.apply)));
}

final jsonPath = JsonPathGrammarDefinition().build();
