import 'package:json_path/src/grammar/expression.dart';
import 'package:json_path/src/grammar/integer.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/selector.dart';
import 'package:json_path/src/selector/array_index.dart';
import 'package:json_path/src/selector/array_slice.dart';
import 'package:json_path/src/selector/callback_filter.dart';
import 'package:json_path/src/selector/expression_filter.dart';
import 'package:json_path/src/selector/field.dart';
import 'package:json_path/src/selector/recursion.dart';
import 'package:json_path/src/selector/sequence.dart';
import 'package:json_path/src/selector/union.dart';
import 'package:json_path/src/selector/wildcard.dart';
import 'package:petitparser/petitparser.dart';
import 'package:json_path/src/it.dart' as it;

final colon = char(':').trim();

final maybeInteger = integer.optional();

final arraySlice =
    (maybeInteger & colon & maybeInteger & (colon & maybeInteger).optional())
        .map((value) =>
            ArraySlice(start: value[0], stop: value[2], step: value[3]?[1]));

final arrayIndex = integer.map(ArrayIndex.new);

final callback = (char('?') &
        ((char('_') | letter()) & (char('_') | letter() | digit()).star())
            .flatten())
    .map((value) => CallbackFilter(value.last));

final wildcard = char('*').map((_) => const Wildcard());

final unionElement = (arraySlice |
        arrayIndex |
        wildcard |
        singleQuotedString.map(Field.new) |
        doubleQuotedString.map(Field.new) |
        callback |
        expression.map(ExpressionFilter.new))
    .trim();

final subsequentUnionElement = (char(',') & unionElement).map(it.last);

final unionContent = (unionElement & subsequentUnionElement.star()).map(
    (value) => [value.first as Selector]
        .followedBy((value.last as List).map((v) => v)));

final union =
    (char('[') & unionContent & char(']')).map((value) => Union(value[1]));

final fieldName = dotString.map((value) => Field(value));

final recursion = (string('..') & (wildcard | union | fieldName | endOfInput()))
    .map((value) => (value.last == null)
        ? const Recursion()
        : Sequence([const Recursion(), value.last]));

final dotMatcher = (char('.') & (fieldName | wildcard)).map(it.last);

final selector = dotMatcher | union | recursion;
