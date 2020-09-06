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
      _start('[]');
    } else if (token == ']') {
      _finish('[]');
    } else {
      _stack.last.children.add(Node(token));
    }
  }

  void _start(String root) {
    _stack.add(Node(root));
  }

  void _finish(String root) {
    final children = <Node>[];
    while (_stack.last.value != root) {
      children.add(_stack.removeLast());
    }
    final bracketExp = _stack.removeLast();
    bracketExp.children.addAll(children.reversed);
    _stack.last.children.add(bracketExp);
  }
}
