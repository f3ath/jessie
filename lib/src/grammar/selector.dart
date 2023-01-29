import 'package:json_path/src/grammar/array_index.dart';
import 'package:json_path/src/grammar/array_slice.dart';
import 'package:json_path/src/grammar/dot_matcher.dart';
import 'package:json_path/src/grammar/expression.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/grammar/wildcard.dart';
import 'package:json_path/src/selector.dart';
import 'package:json_path/src/selector/callback_filter.dart';
import 'package:json_path/src/selector/expression_filter.dart';
import 'package:json_path/src/selector/field.dart';
import 'package:json_path/src/selector/recursion.dart';
import 'package:json_path/src/selector/sequence.dart';
import 'package:json_path/src/selector/union.dart';
import 'package:petitparser/petitparser.dart';

final _callbackName =
    (char('_') | letter()) & (char('_') | letter() | digit()).star();

final _callback =
    _callbackName.flatten().skip(before: char('?')).map(CallbackFilter.new);

final _unionElement = (arraySlice |
        arrayIndex |
        wildcard |
        singleQuotedString.map(Field.new) |
        doubleQuotedString.map(Field.new) |
        _callback |
        expression.map(ExpressionFilter.new))
    .trim();

final _subsequentUnionElement = _unionElement.skip(before: char(','));

final _unionContent = (_unionElement & _subsequentUnionElement.star()).map(
    (value) =>
        [value.first as Selector].followedBy((value.last.cast<Selector>())));

final _union =
    _unionContent.skip(before: char('['), after: char(']')).map(Union.new);

final _fieldName = unquotedString.map(Field.new);

final _recursion = (wildcard | _union | _fieldName | endOfInput())
    .skip(before: string('..'))
    .map((value) => (value == null)
        ? const Recursion()
        : Sequence([const Recursion(), value]));

final selector = dotMatcher | _union | _recursion;
