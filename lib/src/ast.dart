import 'package:json_path/src/node.dart';

/// The Abstract Syntax Tree
class AST {
  AST(Iterable<String> tokens) {
    tokens.skipWhile((token) => token == _root).forEach(_processToken);
  }

  /// The children of the root node
  Iterable<Node> get children => _stack.last.children;

  static const _root = r'$';

  final _stack = <Node>[Node(_root)];

  void _processToken(String token) {
    if (token == '[') {
      _startBrackets();
    } else if (token == ']') {
      _finishBrackets();
    } else {
      _stack.last.children.add(Node(token));
    }
  }

  void _startBrackets() {
    _stack.add(Node('[]'));
  }

  void _finishBrackets() {
    final children = <Node>[];
    while (_stack.last.value != '[]') {
      children.add(_stack.removeLast());
    }
    final bracketExp = _stack.removeLast();
    bracketExp.children.addAll(children.reversed);
    _stack.last.children.add(bracketExp);
  }
}
