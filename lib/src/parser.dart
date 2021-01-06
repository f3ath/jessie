import 'package:json_path/src/selector/array_index.dart';
import 'package:json_path/src/selector/array_slice.dart';
import 'package:json_path/src/selector/field.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/union.dart';
import 'package:json_path/src/selector/wildcard.dart';
import 'package:petitparser/petitparser.dart';

final minus = char('-');
final escape = char(r'\');

final doubleQuote = char('"');
final escapedDoubleQuote = (escape & doubleQuote).map((value) => value.last);

final singleQuote = char("'");
final escapedSingleQuote = (escape & singleQuote).map((value) => value.last);

final control = string(r'/\bfnrt');
final escapedControl = (escape & control).map((value) => value.last);

final wildcard = char('*').map((value) => Wildcard());
final anySymbol = range(0x20, 0x10FFF);

final dotFieldNameChar = minus | char('_') | letter() | digit();
final dotFieldName = dotFieldNameChar.plus().flatten();
final dotWildcard = string('.*').map((value) => const Wildcard());
final dotField = (char('.') & dotFieldName).map((value) => Field(value.last));
final dotMatcher = dotWildcard | dotField;

final allButBackslashAndDoubleQuote =
    ((escape | doubleQuote).not() & anySymbol);
final dInner =
    allButBackslashAndDoubleQuote | escapedDoubleQuote | escapedControl;
final dQuotedString = (doubleQuote & dInner.star().flatten() & doubleQuote)
    .map((value) => Field(value[1], quotationMark: value.first));

final allButBackslashAndSingleQuote = (escape | singleQuote).not() & anySymbol;
final sInner =
    allButBackslashAndSingleQuote | (escape & (singleQuote | control));
final sQuotedString = (singleQuote & sInner.star().flatten() & singleQuote)
    .map((value) => Field(value[1], quotationMark: value.first));

final integer = (minus.optional() & digit().plus()).flatten().map(int.parse);
final colonTrimmed = char(':').trim();
final arraySlice = (integer.optional() &
        colonTrimmed &
        integer.optional() &
        (colonTrimmed & integer.optional()).optional())
    .map((value) =>
        ArraySlice(start: value[0], stop: value[2], step: value[3]?[1]));
final field = sQuotedString | dQuotedString;
final arrayIndex = integer.map((value) => ArrayIndex(value));
final unionElement = (arraySlice | arrayIndex | wildcard | field).trim();
final unionContent = (unionElement & (char(',') & unionElement).star()).map(
    (value) => [value.first as Selector]
        .followedBy((value.last as List).map((v) => v.last as Selector)));

final union =
    (char('[') & unionContent & char(']')).map((value) => Union(value[1]));

final recursion =
    (string('..') & (wildcard | union | dotFieldName)).map<Selector>((value) {
  print(value);
  return Wildcard();
});
final selector = (dotMatcher | union | recursion);
final parser =
    (char(r'$') & selector.star()).end().map<Iterable<Selector>>((value) {
  // print(value);
  return (value.last as List).map((e) => e as Selector);
});
