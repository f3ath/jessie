import 'package:json_path/json_path.dart';
import 'package:json_path/src/grammar/number.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/parser_ext.dart';
import 'package:json_path/src/selector.dart';
import 'package:json_path/src/selector/array_index.dart';
import 'package:json_path/src/selector/array_slice.dart';
import 'package:json_path/src/selector/field.dart';
import 'package:json_path/src/selector/sequence.dart';
import 'package:json_path/src/selector/union.dart';
import 'package:json_path/src/selector/wildcard.dart';
import 'package:petitparser/petitparser.dart';

class MatchSet {
  MatchSet(this.matches);

  final Iterable<JsonPathMatch> matches;

  bool get isSingular => matches.length == 1;

  bool get isEmpty => matches.isEmpty;

  bool get isNotEmpty => matches.isNotEmpty;

  get value => matches.single.value;
}

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

  // final nodeFilter = (listElement | mapElement | dotName)
  //     .plus()
  //     .map((elements) =>
  //         elements.reduce((value, element) => (v) => element(value(v))))
  //     .map<MatchMapper>((value) => (match) => value(match.value));

  ///////////////////////////////////////////

  final _colon = char(':').trim();

  final _maybeInteger = integer.optional();

  final _arraySlice = (_maybeInteger &
          _maybeInteger.skip(before: _colon) &
          _maybeInteger.skip(before: _colon).optional())
      .map((value) =>
          ArraySlice(start: value[0], stop: value[1], step: value[2]));

  final _arrayIndex = integer.map(ArrayIndex.new);

  final _wildcard = char('*').value(const Wildcard());

  final _unionElement = (_arraySlice |
          _arrayIndex |
          _wildcard |
          singleQuotedString.map(Field.new) |
          doubleQuotedString.map(Field.new))
      .trim();

  final _subsequentUnionElement = _unionElement.skip(before: char(','));

  final _unionContent = (_unionElement & _subsequentUnionElement.star()).map(
      (value) =>
          [value.first as Selector].followedBy((value.last.cast<Selector>())));

  final _union =
      _unionContent.skip(before: char('['), after: char(']')).map(Union.new);

  final _fieldName = unquotedString.map(Field.new);

  final _dotMatcher = (_fieldName | _wildcard).skip(before: char('.'));

  final selector = _dotMatcher | _union;

  //////////////////////////////////////

  final nodeFilter =
      selector.plus().map((value) => Sequence(value.cast<Selector>()));

  final currentObject = char('@');

  final node =
      (currentObject & nodeFilter.optional()).map<MatchMapper>((v) => (match) {
            final res = v.last == null ? [match] : [match].expand(v.last.apply);
            return MatchSet(res.cast<JsonPathMatch>());
          });

  comparable(x, y) {
    if (x is MatchSet && !x.isSingular) return false;
    if (y is MatchSet && !y.isSingular) return false;
    return true;
  }

  twoEmpty(x, y) => x is MatchSet && x.isEmpty && y is MatchSet && y.isEmpty;

  valOf(x) {
    if (x is MatchSet && x.isSingular) return x.value;
    return x;
  }

  boolOf(x) {
    if (x is MatchSet) return x.isNotEmpty;
    return x == true;
  }

  final builder = ExpressionBuilder();
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
      string('=='): (a) => (x, y) =>
          twoEmpty(x, y) || (comparable(x, y) && a.eq(valOf(x), valOf(y))),
      string('!='): (a) =>
          (x, y) => a.ne(valOf(x), valOf(y)),
      string('<='): (a) =>
          (x, y) => comparable(x, y) && a.le(valOf(x), valOf(y)),
      string('<'): (a) =>
          (x, y) => comparable(x, y) && a.lt(valOf(x), valOf(y)),
      string('>='): (a) =>
          (x, y) => comparable(x, y) && a.ge(valOf(x), valOf(y)),
      string('>'): (a) =>
          (x, y) => comparable(x, y) && a.gt(valOf(x), valOf(y)),
    },
    {
      string('&&'): (a) => (x, y) => a.and(boolOf(x), boolOf(y)),
    },
    {
      string('||'): (a) => (x, y) => a.or(boolOf(x), boolOf(y)),
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
      .skip(before: string('?'))
      .map<MatchMapper<bool>>((mapper) => (match) => boolOf(mapper(match)));
}

final expression = _build();
