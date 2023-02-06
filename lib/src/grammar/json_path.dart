import 'package:json_path/json_path.dart';
import 'package:json_path/src/grammar/array_index.dart';
import 'package:json_path/src/grammar/array_slice.dart';
import 'package:json_path/src/grammar/dot_matcher.dart';
import 'package:json_path/src/grammar/expression/callback.dart';
import 'package:json_path/src/grammar/expression/primitive.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/grammar/wildcard.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/match_mapper.dart';
import 'package:json_path/src/match_set.dart';
import 'package:json_path/src/selector.dart';
import 'package:json_path/src/selector/expression_filter.dart';
import 'package:json_path/src/selector/field.dart';
import 'package:json_path/src/selector/recursion.dart';
import 'package:json_path/src/selector/sequence.dart';
import 'package:json_path/src/selector/union.dart';
import 'package:petitparser/petitparser.dart';

class JsonPathGrammarDefinition extends GrammarDefinition {
  JsonPathGrammarDefinition({Algebra algebra = const Algebra()})
      : _algebra = algebra;

  final Algebra _algebra;

  @override
  Parser start() => _jsonPath.end();

  static final _unionElement = [
    arraySlice,
    arrayIndex,
    wildcard,
    quotedString.map(Field.new),
    callback,
    ref0(_expressionFilter),
  ].toChoiceParser().trim();

  static final _nextUnionElement = _unionElement.skip(before: char(','));

  static final _unionContent = (_unionElement & _nextUnionElement.star())
      .map((value) => [value.first as Selector].followedBy((value.last)));

  static final _union =
      _unionContent.skip(before: char('['), after: char(']')).map(Union.new);

  static final _recursion = [
    wildcard,
    _union,
    memberNameShorthand,
  ]
      .toChoiceParser()
      .skip(before: string('..'))
      .map((value) => Sequence([const Recursion(), value]));

  static Parser<MatchMapper<bool>> _parenExpr() =>
      _booleanExpr.skip(before: char('(').trim(), after: char(')').trim());

  static Parser<MatchMapper<bool>> _negation(Parser p) =>
      p.skip(before: char('!').trim()).map((mapper) =>
          (match) => !match.context.algebra.isTruthy(mapper(match)));

  static final _comparable = [
    primitive,
    _relPath,
    ref0(_parenExpr),
  ].toChoiceParser();

  static final _eq = '==';
  static final _ne = '!=';
  static final _le = '<=';
  static final _ge = '>=';
  static final _lt = '<';
  static final _gt = '>';
  static final _comparisonOperation = [
    string(_eq),
    string(_ne),
    string(_le),
    string(_ge),
    string(_lt),
    string(_gt),
  ].toChoiceParser();

  static Parser _comparison() =>
      (_comparable & _comparisonOperation.trim() & _comparable).map((v) {
        final left = v[0];
        final op = v[1];
        final right = v[2];

        return (JsonPathMatch match) {
          final a = match.context.algebra;
          final opFunc = <String, bool Function(dynamic, dynamic)>{
                _eq: a.eq,
                _ne: a.ne,
                _le: a.le,
                _ge: a.ge,
                _lt: a.lt,
                _gt: a.gt,
              }[op] ??
              (throw StateError('Invalid op'));
          return opFunc(left(match), right(match));
        };
      });

  static final _booleanExpr = _logicalOrExpr;

  static final _logicalOrExpr = (_logicalAndExpr &
          _logicalAndExpr.skip(before: string('||').trim()).star())
      .map((value) => [value.first].followedBy(value.last ?? []))
      .map<MatchMapper<bool>>((value) => (match) => value
          .any((element) => match.context.algebra.isTruthy(element(match))));

  static final _logicalAndExpr = (_basicExpr &
          _basicExpr.skip(before: string('&&').trim()).star())
      .map((value) => [value.first].followedBy(value.last ?? []))
      .map<MatchMapper<bool>>((value) => (match) => value
          .every((element) => match.context.algebra.isTruthy(element(match))));

  static Parser _negatable(Parser p) =>
      [ref1(_negation, p), p].toChoiceParser();

  static final _basicExpr = [
    ref0(_comparison),
    ref1(_negatable, ref0(_parenExpr)),
    ref1(_negatable, _filterPath),
  ].toChoiceParser();

  static final _filterPath = [
    _relPath,
    _jsonPath,
    // TODO: add functionExpr
  ].toChoiceParser();

  static Parser<Selector> _expressionFilter() =>
      _booleanExpr.skip(before: string('?')).map((ExpressionFilter.new));

  static final _segment = [
    dotMatcher,
    _union,
    _recursion,
  ].toChoiceParser().cast<Selector>();

  static final _segmentSequence = _segment.star().map(Sequence.new);

  static final _jsonPath = _segmentSequence.skip(before: char(r'$'));

  static final _relPath = _segmentSequence
      .skip(before: char('@'))
      .map<MatchMapper>(
          (sequence) => (match) => MatchSet([match].expand(sequence.apply)));
}

final jsonPath = JsonPathGrammarDefinition().build();
