import 'package:json_path/json_path.dart';
import 'package:json_path/src/grammar/number.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/parser_ext.dart';
import 'package:petitparser/petitparser.dart';

Parser<MatchMapper<bool>> _build() {
  getByIndex(int index) => (list) {
        if (list is List && index < list.length && index >= 0) {
          return list[index];
        }
      };
  getByKey(key) => (map) {
        if (map is Map && map.containsKey(key)) {
          return map[key];
        }
      };
  final listElement =
      integer.skip(before: char('['), after: char(']')).map(getByIndex);

  final mapElement =
      quotedString.skip(before: char('['), after: char(']')).map(getByKey);

  final dotName = unquotedString.skip(before: char('.')).map(getByKey);

  final nodeFilter = (listElement | mapElement | dotName)
      .plus()
      .map((elements) =>
          elements.reduce((value, element) => (v) => element(value(v))))
      .map<MatchMapper>((value) => (match) => value(match.value));

  final currentObject =
      char('@').map<MatchMapper>((_) => (match) => match.value);

  final node = (currentObject & nodeFilter.optional())
      .map<MatchMapper>((v) => v.lastWhere((e) => e != null));

  final builder = ExpressionBuilder<MatchMapper>();
  builder.group()
    ..primitive(string('null').value(null).toMatchMapper())
    ..primitive(string('false').value(false).toMatchMapper())
    ..primitive(string('true').value(true).toMatchMapper())
    ..primitive(number.toMatchMapper())
    ..primitive(quotedString.toMatchMapper())
    ..primitive(node)
    ..wrapper(char('(').trim(), char(')').trim(), (l, a, r) => a);

  builder.group().prefix(char('!').trim(),
      (_, mapper) => (match) => !match.context.algebra.isTruthy(mapper(match)));
  for (final operations in <
      Map<Parser<String>, bool Function(dynamic, dynamic) Function(Algebra)>>[
    {
      string('=='): (a) => a.eq,
      string('!='): (a) => a.ne,
      string('<='): (a) => a.le,
      string('<'): (a) => a.lt,
      string('>='): (a) => a.ge,
      string('>'): (a) => a.gt,
    },
    {
      string('&&'): (a) => a.and,
    },
    {
      string('||'): (a) => a.or,
    },
  ]) {
    final group = builder.group();
    operations.forEach((parser, operation) {
      group.left(
          parser.trim(),
          (left, _, right) => (match) =>
              operation(match.context.algebra)(left(match), right(match)));
    });
  }
  return builder
      .build()
      .skip(before: string('?('), after: char(')'))
      .map<MatchMapper<bool>>(
          (mapper) => (match) => match.context.algebra.isTruthy(mapper(match)));
}

final expression = _build();
