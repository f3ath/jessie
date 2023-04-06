import 'package:json_path/src/node.dart';
import 'package:json_path/src/selector.dart';

Selector sequenceSelector(Iterable<Selector> selectors) {
  final filter = selectors.fold<_Filter>((v) => v,
      (filter, selector) => (nodes) => filter(nodes).expand(selector));
  return (node) => filter([node]);
}

typedef _Filter = Iterable<Node> Function(Iterable<Node> nodes);
