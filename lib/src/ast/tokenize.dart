Iterable<String> tokenize(String expr) =>
    _tokens.allMatches(expr).map((match) => match.group(0).toString());

final _tokens = RegExp([
  r'\$', // root
  r'\[', // left bracket
  r'\]', // right bracket
  r'\.\.', // recursion
  r'\.', // child
  r'\*', // wildcard
  r'\:', // slice
  r'\,', // union
  r'\?', // filter
  r"'(?:[^'\\]|\\.)*'", // quoted string
  r'-?\d+', // number
  r'([A-Za-z_-][A-Za-z_\d-]*)', // field
].join('|'));
