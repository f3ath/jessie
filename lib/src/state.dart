import 'package:jessie/src/ast.dart';
import 'package:jessie/src/selector/all_in_array.dart';
import 'package:jessie/src/selector/field.dart';
import 'package:jessie/src/selector/index.dart';
import 'package:jessie/src/selector/recursive.dart';
import 'package:jessie/src/selector/selector.dart';

abstract class State {
  State process(Node node);

  Selector get selector;
}

class Ready implements State {
  Ready(this.selector);

  @override
  final Selector selector;

  @override
  State process(Node node) {
    if (node.value == '[') {
      return Ready(selector.then(_brackets(node.children)));
    }
    if (node.value == '.') {
      return AwaitingField(selector);
    }
    if (node.value == '..') {
      return Ready(selector.then(Recursive()));
    }
    throw StateError('Got ${node.value} in $this');
  }

  Selector _brackets(List<Node> nodes) {
    if (nodes.length == 1) {
      final node = nodes.single;
      if (node.value == '*') return AllInArray();
      if (node.isNumber) return Index(int.parse(nodes.first.value));
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
    return Ready(selector.then(Field(node.value)));
  }
}
