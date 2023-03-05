import 'package:json_path/src/grammar/node_selector.dart';
import 'package:json_path/src/node/node.dart';

NodeSelector sequenceSelector(Iterable<NodeSelector> selectors) {
  final filter = selectors.fold<_Filter>((v) => v,
      (filter, selector) => (nodes) => filter(nodes).expand(selector));
  return (node) => filter([node]);
}

typedef _Filter = Iterable<Node> Function(Iterable<Node> nodes);
