import 'package:json_path/src/selector/array_index.dart';
import 'package:json_path/src/selector/array_slice.dart';
import 'package:json_path/src/selector/field.dart';
import 'package:json_path/src/selector/named_filter.dart';
import 'package:json_path/src/selector/recursion.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/sequence.dart';
import 'package:json_path/src/selector/union.dart';
import 'package:json_path/src/selector/wildcard.dart';
import 'package:petitparser/petitparser.dart';

final minus = char('-');
final escape = char(r'\');
final zero = char('0');
final nonZeroDigit = anyOf('123456789');
final hexDigit = anyOf('0123456789ABCDEF');

final unicodeSymbol = (string(r'\u') & hexDigit.repeat(4).flatten())
    .map((value) => String.fromCharCode(int.parse(value.last, radix: 16)));

final doubleQuote = char('"');
final escapedDoubleQuote = (escape & doubleQuote).map((_) => '"');

final singleQuote = char("'");
final escapedSingleQuote = (escape & singleQuote).map((_) => "'");

final escapedSlash = string(r'\/').map((_) => r'/');
final escapedBackSlash = string(r'\\').map((_) => r'\');
final escapedBackspace = string(r'\b').map((_) => '\b');
final escapedFormFeed = string(r'\f').map((_) => '\f');
final escapedNewLine = string(r'\n').map((_) => '\n');
final escapedReturn = string(r'\r').map((_) => '\r');
final escapedTab = string(r'\t').map((_) => '\t');

final escapedControl = escapedSlash |
    escapedBackSlash |
    escapedBackspace |
    escapedFormFeed |
    escapedNewLine |
    escapedReturn |
    escapedTab;

final wildcard = char('*').map((_) => const Wildcard());

final fieldNameChar =
    minus | char('_') | letter() | digit() | range(0x80, 0x10FFF);
final fieldName = fieldNameChar.plus().flatten().map((value) => Field(value));

final dotMatcher =
    (char('.') & (fieldName | wildcard)).map((value) => value.last);

final doubleUnescaped =
    range(0x20, 0x21) | range(0x23, 0x5B) | range(0x5D, 0x10FFF);

final doubleInner =
    (doubleUnescaped | escapedDoubleQuote | escapedControl | unicodeSymbol)
        .star()
        .map((value) => value.join(''));

final doubleQuotedString =
    (doubleQuote & doubleInner & doubleQuote).map((value) => Field(value[1]));

final singleUnescaped =
    range(0x20, 0x26) | range(0x28, 0x5B) | range(0x5D, 0x10FFF);

final singleInner =
    (singleUnescaped | escapedSingleQuote | escapedControl | unicodeSymbol)
        .star()
        .map((value) => value.join(''));

final singleQuotedString =
    (singleQuote & singleInner & singleQuote).map((value) => Field(value[1]));

final integer = (zero | (minus.optional() & nonZeroDigit & digit().star()))
    .flatten()
    .map(int.parse);

final colon = char(':').trim();

final maybeInteger = integer.optional();

final arraySlice =
    (maybeInteger & colon & maybeInteger & (colon & maybeInteger).optional())
        .map((value) =>
            ArraySlice(start: value[0], stop: value[2], step: value[3]?[1]));

final arrayIndex = integer.map((value) => ArrayIndex(value));

final namedFilter = (char('?') &
        ((char('_') | letter()) & (char('_') | letter() | digit()).star())
            .flatten())
    .map((value) => NamedFilter(value.last));

final unionElement = (arraySlice |
        arrayIndex |
        wildcard |
        singleQuotedString |
        doubleQuotedString |
        namedFilter)
    .trim();

final subsequentUnionElement =
    (char(',') & unionElement).map((value) => value.last);

final unionContent = (unionElement & subsequentUnionElement.star()).map(
    (value) => [value.first as Selector]
        .followedBy((value.last as List).map((v) => v as Selector)));

final union =
    (char('[') & unionContent & char(']')).map((value) => Union(value[1]));

final recursion = (string('..') & (wildcard | union | fieldName | endOfInput()))
    .map((value) => (value.last == null)
        ? const Recursion()
        : Sequence([const Recursion(), value.last]));

final selector = dotMatcher | union | recursion;

final jsonPath = (char(r'$') & selector.star())
    .end()
    .map((value) => Sequence((value.last as List).map((e) => e as Selector)));
