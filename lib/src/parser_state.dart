import 'package:json_path/src/node.dart';
import 'package:json_path/src/selector/field.dart';
import 'package:json_path/src/selector/index.dart';
import 'package:json_path/src/selector/list_union.dart';
import 'package:json_path/src/selector/list_wildcard.dart';
import 'package:json_path/src/selector/object_union.dart';
import 'package:json_path/src/selector/object_wildcard.dart';
import 'package:json_path/src/selector/recursive.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/slice.dart';

/// AST parser state
abstract class ParserState {
  /// Processes the node. Returns the next state
  ParserState process(Node node);

  /// Selector made from the tree
  Selector get selector;
}

/// Ready to process the next node
class Ready implements ParserState {
  Ready(this.selector);

  @override
  final Selector selector;

  @override
  ParserState process(Node node) {
    switch (node.value) {
      case '[]':
        return Ready(selector.then(bracketExpression(node.children)));
      case '.':
        return AwaitingField(selector);
      case '..':
        return Ready(selector.then(Recursive()));
      case '*':
        return Ready(selector.then(ObjectWildcard()));
      default:
        return Ready(selector.then(Field(node.value)));
    }
  }

  Selector bracketExpression(List<Node> nodes) {
    if (nodes.isEmpty) throw FormatException('Empty brackets');
    if (nodes.length == 1) return singleValueBrackets(nodes.single);
    return multiValueBrackets(nodes);
  }

  Selector singleValueBrackets(Node node) {
    if (node.isWildcard) return ListWildcard();
    if (node.isNumber) return Index(node.intValue);
    if (node.isQuoted) return Field(node.unquoted);
    throw FormatException('Unexpected bracket expression');
  }

  Selector multiValueBrackets(List<Node> nodes) {
    if (_isSlice(nodes)) return _slice(nodes);
    return _union(nodes);
  }

  bool _isSlice(List<Node> nodes) => nodes.any((node) => node.value == ':');

  Selector _union(List<Node> nodes) {
    final filtered = nodes.where((_) => _.value != ',');
    if (nodes.first.isNumber) {
      return ListUnion(filtered.map((_) => _.intValue).toList());
    }
    return ObjectUnion(
        filtered.map((_) => _.isQuoted ? _.unquoted : _.value).toList());
  }

  Slice _slice(List<Node> nodes) {
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
}

class AwaitingField implements ParserState {
  AwaitingField(this.selector);

  @override
  final Selector selector;

  @override
  ParserState process(Node node) {
    if (node.isWildcard) {
      return Ready(selector.then(ObjectWildcard()));
    }
    return Ready(selector.then(Field(node.value)));
  }
}
