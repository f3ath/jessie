import 'package:json_path/json_path.dart';
import 'package:json_path/src/grammar/integer.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/parser_ext.dart';
import 'package:json_path/src/selector/expression_filter.dart';
import 'package:petitparser/petitparser.dart';

Parser<Extractor<bool>> _build() {
  final aTrue = string('true').asLiteral(true);
  final aFalse = string('false').asLiteral(false);
  final aNull = string('null').asLiteral(null);

  final listElement =
      integer.skip(before: char('['), after: char(']')).map((key) => (v) {
            if (v is List && key < v.length && key >= 0) {
              return v[key];
            }
          });

  final mapElement =
      quotedString.skip(before: char('['), after: char(']')).map((key) => (v) {
            if (v is Map && v.containsKey(key)) {
              return v[key];
            }
          });

  final dotName = unquotedString.skip(before: char('.')).map((key) => (v) {
        if (v is Map && v.containsKey(key)) {
          return v[key];
        }
      });

  final nodeFilter = (listElement | mapElement | dotName)
      .plus()
      .map((elements) =>
          elements.reduce((value, element) => (v) => element(value(v))))
      .map<Extractor>((value) => (match) => value(match.value));

  final currentObject = char('@').map<Extractor>((_) => (match) => match.value);

  final node = (currentObject & nodeFilter.optional())
      .map<Extractor>((v) => v.lastWhere((e) => e != null));

  final builder = ExpressionBuilder<Extractor>();
  builder.group()
    ..primitive(integer.asExtractor())
    ..primitive(quotedString.asExtractor())
    ..primitive(aFalse.asExtractor())
    ..primitive(aTrue.asExtractor())
    ..primitive(aNull.asExtractor())
    ..primitive(node)
    ..wrapper(char('(').trim(), char(')').trim(), (l, a, r) => a);

  for (final group in <
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
    final g = builder.group();
    group.forEach((parser, op) {
      g.left(
          parser.trim(),
          (left, _, right) =>
              (match) => op(match.context.algebra)(left(match), right(match)));
    });
  }
  return builder
      .build()
      .skip(before: string('?('), after: char(')'))
      .map<Extractor<bool>>(
          (eval) => (match) => match.context.algebra.isTruthy(eval(match)));
}

final expression = _build();
