class Node {
  Node(this.value);

  /// Builds the AST from the list of tokens
  static List<Node> list(Iterable<String> tokens) {
    const root = r'$';
    final stack = <Node>[Node(root)];
    tokens.skipWhile((token) => token == root).forEach((token) {
      if (token == '[') {
        stack.add(Node(token));
        return;
      }
      if (token == ']' || token == ')') {
        final closing = token == ']' ? '[' : '(';
        final children = <Node>[];
        while (stack.last.value != closing) {
          children.add(stack.removeLast());
        }
        final brackets = stack.removeLast();
        brackets.children.addAll(children.reversed);
        stack.last.children.add(brackets);
        return;
      }
      stack.last.children.add(Node(token));
    });

    return stack.last.children;
  }

  final String value;
  final children = <Node>[];

  bool get isNumber => RegExp(r'^-?\d+$').hasMatch(value);

  bool get isQuoted => value.startsWith("'");

  String get unquoted => value
      .substring(1, value.length - 1)
      .replaceAll(r'\\', r'\')
      .replaceAll(r"\'", r"'");

  int get intValue => int.parse(value);
}
