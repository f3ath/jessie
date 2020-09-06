import 'package:json_path/src/ast/node.dart';

/// The Abstract Syntax Tree
class AST {
  AST(Iterable<String> tokens) {
    tokens.skipWhile((_) => _ == r'$').forEach(_processToken);
  }

  /// The children of the root node
  Iterable<Node> get nodes => _stack.last.children;

  final _stack = <Node>[Node('')];

  void _processToken(String token) {
    if (token == '[') {
      _stack.add(Node(token));
    } else if (token == ']') {
      final node = _stack.removeLast();
      if (node.value != '[') throw FormatException('Mismatching brackets');
      _stack.last.children.add(node);
    } else {
      _stack.last.children.add(Node(token));
    }
  }
}
