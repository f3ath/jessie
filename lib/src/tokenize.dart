/// Parses a JSONPath expression into a list of tokens
Iterable<String> tokenize(String expr) sync* {
  var pos = 0;
  while (pos < expr.length) {
    var token = '';
    var insideQuotedString = false;
    var escapeMode = false;
    while (pos < expr.length) {
      final char = expr[pos];
      if (char == "'" && !escapeMode) {
        insideQuotedString = !insideQuotedString;
      }
      escapeMode = char == r'\';
      if (insideQuotedString) {
        token += char;
        pos += 1;
        continue;
      }
      if (_singles.contains(char)) {
        if (token.isNotEmpty) {
          break;
        }
        if (expr.length > pos + 1) {
          final nextTwoChars = char + expr[pos + 1];
          if (_doubles.contains(nextTwoChars)) {
            token = nextTwoChars;
            pos += 2;
            break;
          }
        }
        token = char;
        pos += 1;
        break;
      }
      token += char;
      pos += 1;
    }
    if (insideQuotedString) throw FormatException('Unmatched quote');
    yield token;
  }
}

const _singles = [
  r'$',
  '[',
  ']',
  '.',
  '*',
  ':',
  ',',
];

const _doubles = [
  '..',
];
