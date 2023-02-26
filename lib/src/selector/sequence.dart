import 'package:json_path/src/node.dart';
import 'package:json_path/src/selector.dart';

class Sequence implements Selector {
  Sequence(Iterable<Selector> selectors)
      : _filter = selectors.fold<_Filter>(
            (_) => _,
            (filter, selector) => (nodes) =>
                filter(nodes).map(selector.apply).expand((_) => _));

  final _Filter _filter;

  @override
  Iterable<Node> apply(Node node) => _filter([node]);
}

typedef _Filter = Iterable<Node> Function(Iterable<Node> nodes);
