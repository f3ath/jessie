import 'package:json_path/src/selector/array_index.dart';
import 'package:json_path/src/selector/array_slice.dart';
import 'package:json_path/src/selector/dot_field.dart';
import 'package:json_path/src/selector/dot_wildcard.dart';
import 'package:json_path/src/selector/quoted_field.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/union.dart';
import 'package:json_path/src/selector/union_element.dart';
import 'package:json_path/src/selector/wildcard.dart';
import 'package:petitparser/petitparser.dart';

final minus = char('-');
final escape = char(r'\');
final dQuote = char('"');
final sQuote = char("'");
final wildcard = char('*').map((value) => Wildcard());
final anySymbol = range(0x20, 0x10FFF);
final control = string(r'/\bfnrt');

final dotFieldNameChar = minus | char('_') | letter() | digit();
final dotFieldName = dotFieldNameChar.plus().flatten();
final dotWildcard = string('.*').map((value) => const DotWildcard());
final dotField =
    (char('.') & dotFieldName).map((value) => DotField(value.last));
final dotMatcher = dotWildcard | dotField;

final allButBackslashAndDoubleQuote = ((escape | dQuote).not() & anySymbol);
final dInner = allButBackslashAndDoubleQuote | (escape & (dQuote | control));
final dQuotedString = (dQuote & dInner.star().flatten() & dQuote)
    .flatten()
    .map((value) => QuotedField(value));

final allButBackslashAndSingleQuote = (escape | sQuote).not() & anySymbol;
final sInner = allButBackslashAndSingleQuote | (escape & (sQuote | control));
final sQuotedString = (sQuote & sInner.star().flatten() & sQuote)
    .flatten()
    .map((value) => QuotedField(value));

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
    (value) => [value.first as UnionElement]
        .followedBy((value.last as List).map((v) => v.last as UnionElement)));

final union =
    (char('[') & unionContent & char(']')).map((value) => Union(value[1]));

final recursion = string('..') & (wildcard | union | dotFieldName);
final selector = (dotMatcher | union | recursion);
final parser =
    (char(r'$') & selector.star()).end().map<Iterable<Selector>>((value) {
  // print(value);
  return (value.last as List).map((e) => e as Selector);
});
