import 'package:json_path/json_path.dart';
import 'package:json_path/src/grammar/array_index.dart';
import 'package:json_path/src/grammar/array_slice.dart';
import 'package:json_path/src/grammar/dot_matcher.dart';
import 'package:json_path/src/grammar/number.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/grammar/wildcard.dart';
import 'package:json_path/src/match_mapper.dart';
import 'package:json_path/src/match_set.dart';
import 'package:json_path/src/parser_ext.dart';
import 'package:json_path/src/selector.dart';
import 'package:json_path/src/selector/field.dart';
import 'package:json_path/src/selector/sequence.dart';
import 'package:json_path/src/selector/union.dart';
import 'package:petitparser/petitparser.dart';

Parser<MatchMapper<bool>> _build() {
  final unionElement =
      (arraySlice | arrayIndex | wildcard | quotedString.map(Field.new)).trim();

  final subsequentUnionElement = unionElement.skip(before: char(','));

  final unionContent = (unionElement & subsequentUnionElement.star()).map(
      (value) =>
          [value.first as Selector].followedBy((value.last.cast<Selector>())));

  final union =
      unionContent.skip(before: char('['), after: char(']')).map(Union.new);

  final nodeFilter = (dotMatcher | union)
      .plus()
      .map((value) => Sequence(value.cast<Selector>()));

  final node =
      (char('@') & nodeFilter.optional()).map<MatchMapper>((v) => (match) {
            final res = v.last == null ? [match] : [match].expand(v.last.apply);
            return MatchSet(res.cast<JsonPathMatch>());
          });

  final builder = ExpressionBuilder<MatchMapper>();
  builder.group()
    ..primitive(string('null').value(null).toMatchMapper())
    ..primitive(string('false').value(false).toMatchMapper())
    ..primitive(string('true').value(true).toMatchMapper())
    ..primitive(number.toMatchMapper())
    ..primitive(quotedString.toMatchMapper())
    ..primitive(node)
    ..wrapper(char('(').trim(), char(')').trim(), (l, a, r) => a);

  builder.group().prefix(
      char('!').trim(),
      (_, mapper) =>
          (JsonPathMatch match) => match.context.algebra.not(mapper(match)));

  for (final precedenceGroup
      in <Map<String, bool Function(dynamic, dynamic) Function(Algebra)>>[
    {
      '==': (a) => a.eq,
      '!=': (a) => a.ne,
      '<=': (a) => a.le,
      '<': (a) => a.lt,
      '>=': (a) => a.ge,
      '>': (a) => a.gt,
    },
    {
      '&&': (a) => a.and,
    },
    {
      '||': (a) => a.or,
    },
  ]) {
    final group = builder.group();
    precedenceGroup.forEach((expr, operation) {
      group.left(
          string(expr).trim(),
          (left, _, right) => (match) =>
              operation(match.context.algebra)(left(match), right(match)));
    });
  }
  return builder.build().skip(before: string('?')).map<MatchMapper<bool>>(
      (mapper) => (match) => match.context.algebra.isTruthy(mapper(match)));
}

final expression = _build();
