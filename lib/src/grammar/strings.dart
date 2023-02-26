import 'package:json_path/src/parser_ext.dart';
import 'package:json_path/src/selectors.dart';
import 'package:petitparser/petitparser.dart';

final _escape = char(r'\');
final _doubleQuote = char('"');

final _singleQuote = char("'");

final _escapedSlash = string(r'\/').value(r'/');
final _escapedBackSlash = string(r'\\').value(r'\');

final _escapedBackspace = string(r'\b').value('\b');
final _escapedFormFeed = string(r'\f').value('\f');

final _escapedNewLine = string(r'\n').value('\n');
final _escapedReturn = string(r'\r').value('\r');
final _escapedTab = string(r'\t').value('\t');
final _escapedControl = _escapedSlash |
    _escapedBackSlash |
    _escapedBackspace |
    _escapedFormFeed |
    _escapedNewLine |
    _escapedReturn |
    _escapedTab;

// The parser does not seem to support Unicode 6.0 boundary (0x10FFFF).
// We're limiting ourselves to Unicode 1.0 boundary (0xFFFF).
final _unicodeBoundary = String.fromCharCode(0xFFFF);

// Exclude double quote '"' and back slash '\'
final _doubleUnescaped =
    range(' ', '!') | range('#', '[') | range(']', _unicodeBoundary);

final _hexDigit = anyOf('0123456789ABCDEFabcdef');

final _unicodeSymbol = (string(r'\u') & _hexDigit.repeat(4).flatten())
    .map((value) => String.fromCharCode(int.parse(value.last, radix: 16)));

final _escapedDoubleQuote = (_escape & _doubleQuote).map((_) => '"');

final _doubleInner =
    (_doubleUnescaped | _escapedDoubleQuote | _escapedControl | _unicodeSymbol)
        .star()
        .map((value) => value.join(''));

// Exclude single quote "'" and back slash "\"
final _singleUnescaped =
    range(' ', '&') | range('(', '[') | range(']', _unicodeBoundary);

final _escapedSingleQuote = (_escape & _singleQuote).map((_) => "'");

final _singleInner =
    (_singleUnescaped | _escapedSingleQuote | _escapedControl | _unicodeSymbol)
        .star()
        .map((value) => value.join(''));

final _doubleQuotedString =
    _doubleInner.skip(before: _doubleQuote, after: _doubleQuote);

final _singleQuotedString =
    _singleInner.skip(before: _singleQuote, after: _singleQuote);

final _nameFirst =
    (char('_') | letter() | range(String.fromCharCode(0x80), _unicodeBoundary))
        .plus()
        .flatten();

final _nameChar = digit() | _nameFirst;

final quotedString = (_singleQuotedString | _doubleQuotedString).cast<String>();

final memberNameShorthand =
    (_nameFirst & _nameChar.star()).flatten().map(fieldSelector);
