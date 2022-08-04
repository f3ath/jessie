import 'package:petitparser/petitparser.dart';

final _escape = char(r'\');
final _doubleQuote = char('"');

final _singleQuote = char("'");

final _escapedSlash = string(r'\/').map((_) => r'/');
final _escapedBackSlash = string(r'\\').map((_) => r'\');

final _escapedBackspace = string(r'\b').map((_) => '\b');
final _escapedFormFeed = string(r'\f').map((_) => '\f');

final _escapedNewLine = string(r'\n').map((_) => '\n');
final _escapedReturn = string(r'\r').map((_) => '\r');
final _escapedTab = string(r'\t').map((_) => '\t');
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

// ***************************************************************************

final doubleQuotedString = _doubleQuote
    .seq(_doubleInner)
    .seq(_doubleQuote)
    .map<String>((value) => value[1]);

final singleQuotedString = (_singleQuote & _singleInner & _singleQuote)
    .map<String>((value) => value[1]);

final quotedString = singleQuotedString | doubleQuotedString;

final unquotedString = (anyOf('-_') |
        letter() |
        digit() |
        range(String.fromCharCode(0x80), _unicodeBoundary))
    .plus()
    .flatten();
