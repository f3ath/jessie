import 'package:json_path/src/ast/node.dart';
import 'package:json_path/src/predicate.dart';
import 'package:json_path/src/selector/filter.dart';
import 'package:json_path/src/selector/list_union.dart';
import 'package:json_path/src/selector/list_wildcard.dart';
import 'package:json_path/src/selector/object_union.dart';
import 'package:json_path/src/selector/object_wildcard.dart';
import 'package:json_path/src/selector/recursive.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/slice.dart';

/// AST parser state
abstract class ParsingState {
  /// Processes the node. Returns the next state
  ParsingState process(Node node, Map<String, Predicate> filters);

  /// Selector made from the tree
  Selector get selector;
}

/// Ready to process the next node
class Ready implements ParsingState {
  Ready(this.selector);

  @override
  final Selector selector;

  @override
  ParsingState process(Node node, Map<String, Predicate> filters) {
    switch (node.value) {
      case '[':
        return Ready(selector.then(_brackets(node.children, filters)));
      case '.':
        return AwaitingField(selector);
      case '..':
        return Ready(selector.then(Recursive()));
      case '*':
        return Ready(selector.then(ObjectWildcard()));
      default:
        return Ready(selector.then(ObjectUnion([node.value])));
    }
  }

  Selector _brackets(List<Node> nodes, Map<String, Predicate> filters) {
    if (nodes.isEmpty) throw FormatException('Empty brackets');
    if (nodes.length == 1) return _singleValueBrackets(nodes.single);
    return _multiValueBrackets(nodes, filters);
  }

  Selector _singleValueBrackets(Node node) {
    if (node.isWildcard) return ListWildcard();
    if (node.isNumber) return ListUnion([node.intValue]);
    if (node.isQuoted) return ObjectUnion([node.unquoted]);
    throw FormatException('Unexpected bracket expression');
  }

  Selector _multiValueBrackets(
      List<Node> nodes, Map<String, Predicate> filters) {
    if (_isFilter(nodes)) return _filter(nodes, filters);
    if (_isSlice(nodes)) return _slice(nodes);
    return _union(nodes);
  }

  Filter _filter(List<Node> nodes, Map<String, Predicate> filters) {
    final name = nodes[1].value;
    if (!filters.containsKey(name)) {
      throw FormatException('Filter not found: "${name}"');
    }
    return Filter(name, filters[name]);
  }

  bool _isFilter(List<Node> nodes) => nodes.first.value == '?';

  bool _isSlice(List<Node> nodes) => nodes.any((node) => node.value == ':');

  Selector _union(List<Node> nodes) {
    final filtered = nodes.where((_) => _.value != ',');
    if (filtered.every((_) => _.isNumber)) {
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

class AwaitingField implements ParsingState {
  AwaitingField(this.selector);

  @override
  final Selector selector;

  @override
  ParsingState process(Node node, Map<String, Predicate> filters) {
    if (node.isWildcard) {
      return Ready(selector.then(ObjectWildcard()));
    }
    return Ready(selector.then(ObjectUnion([node.value])));
  }
}
