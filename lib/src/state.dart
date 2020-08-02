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
        return Ready(selector.then(brackets(node.children)));
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

  Selector brackets(List<Node> nodes) {
    if (nodes.isEmpty) throw FormatException('Empty brackets');
    if (nodes.length == 1) return singleValueBrackets(nodes.single);
    return multiValueBrackets(nodes);
  }

  Slice multiValueBrackets(List<Node> nodes) {
    int first;
    int last;
    int step;
    var colons = 0;
    nodes.forEach((node) {
      if (node.value == ':') {
        colons++;
        return;
      }
      if (colons == 0) {
        first = node.intValue;
        return;
      }
      if (colons == 1) {
        last = node.intValue;
        return;
      }
      step = node.intValue;
    });
    return Slice(first: first, last: last, step: step);
  }

  Selector singleValueBrackets(Node node) {
    if (node.value == '*') return AllInArray();
    if (node.isNumber) return Index(node.intValue);
    if (node.isQuoted) return Field(node.unquoted);
    throw FormatException('Unexpected bracket expression');
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
