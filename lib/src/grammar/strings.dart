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

final _doubleUnescaped =
    range(0x20, 0x21) | range(0x23, 0x5B) | range(0x5D, 0x10FFF);

final _hexDigit = anyOf('0123456789ABCDEF');

final _unicodeSymbol = (string(r'\u') & _hexDigit.repeat(4).flatten())
    .map((value) => String.fromCharCode(int.parse(value.last, radix: 16)));

final _escapedDoubleQuote = (_escape & _doubleQuote).map((_) => '"');

final _doubleInner =
    (_doubleUnescaped | _escapedDoubleQuote | _escapedControl | _unicodeSymbol)
        .star()
        .map((value) => value.join(''));

final _singleUnescaped =
    range(0x20, 0x26) | range(0x28, 0x5B) | range(0x5D, 0x10FFF);

final _escapedSingleQuote = (_escape & _singleQuote).map((_) => "'");

final _singleInner =
    (_singleUnescaped | _escapedSingleQuote | _escapedControl | _unicodeSymbol)
        .star()
        .map((value) => value.join(''));

// ***************************************************************************

final doubleQuotedString =
    (_doubleQuote & _doubleInner & _doubleQuote).map((value) => value[1]);

final singleQuotedString =
    (_singleQuote & _singleInner & _singleQuote).map((value) => value[1]);

final dotString =
    (anyOf('-_') | letter() | digit() | range(0x80, 0x10FFF)).plus().flatten();
