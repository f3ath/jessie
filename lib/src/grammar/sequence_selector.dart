import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/node.dart';

SelectorFun sequenceSelector(Iterable<SelectorFun> selectors) {
  final filter = selectors.fold<_Filter>((v) => v,
      (filter, selector) => (nodes) => filter(nodes).expand(selector));
  return (node) => filter([node]);
}

typedef _Filter = Iterable<Node> Function(Iterable<Node> nodes);
