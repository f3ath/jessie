import 'package:json_path/src/ast.dart';
import 'package:json_path/src/selector/all_in_array.dart';
import 'package:json_path/src/selector/all_values.dart';
import 'package:json_path/src/selector/field.dart';
import 'package:json_path/src/selector/index.dart';
import 'package:json_path/src/selector/recursive.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/slice.dart';

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
        return Ready(selector.then(_bracketSelector(node.children)));
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

  Selector _bracketSelector(List<Node> nodes) {
    if (nodes.length == 1) {
      final node = nodes.single;
      if (node.value == '*') return AllInArray();
      if (node.isNumber) return Index(int.parse(nodes.first.value));
      if (node.value.startsWith("'")) {
        return Field(node.value.substring(1, node.value.length - 1));
      }
    } else if (nodes.length > 1) {
      int first;
      int last;
      int step;
      var colons = 0;
      nodes.map((_) => _.value).forEach((val) {
        if (val == ':') {
          colons++;
          return;
        }
        if (colons == 0) {
          first = int.parse(val);
          return;
        }
        if (colons == 1) {
          last = int.parse(val);
          return;
        }
        step = int.parse(val);
      });
      return Slice(first: first, last: last, step: step);
    }

    throw StateError('Unexpected bracket expression');
  }
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
