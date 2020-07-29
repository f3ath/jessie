import 'package:json_path/src/ast.dart';
import 'package:json_path/src/selector/all_in_array.dart';
import 'package:json_path/src/selector/all_values.dart';
import 'package:json_path/src/selector/field.dart';
import 'package:json_path/src/selector/index.dart';
import 'package:json_path/src/selector/recursive.dart';
import 'package:json_path/src/selector/selector.dart';

/// AST parser state
abstract class State {
  /// Processes the node. Returns the next state
  State process(Node node);

  /// Selector made from the tree
  Selector get selector;
}

/// Ready to process the next node
class Ready implements State {
  Ready(this.selector);

  @override
  final Selector selector;

  @override
  State process(Node node) {
    switch (node.value) {
      case '[':
        return Ready(selector.then(_bracketExpression(node.children)));
      case '.':
        return AwaitingField(selector);
      case '..':
        return Ready(selector.then(Recursive()));
      case '*':
        return Ready(selector.then(AllValues()));
      default:
        return Ready(selector.then(Field(node.value)));
    }
  }

  Selector _bracketExpression(List<Node> nodes) {
    final node = nodes.single;
    if (node.value == '*') return AllInArray();
    if (node.isNumber) return Index(int.parse(nodes.first.value));
    if (node.value.startsWith("'")) return Field(_unquote(node.value));
    throw StateError('Unexpected bracket expression');
  }

  String _unquote(String s) => s.substring(1, s.length - 1);
}

class AwaitingField implements State {
  AwaitingField(this.selector);

  @override
  final Selector selector;

  @override
  State process(Node node) {
    if (node.value == '*') {
      return Ready(selector.then(AllValues()));
    }
    return Ready(selector.then(Field(node.value)));
  }
}
