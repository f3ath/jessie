import 'package:json_path/src/node.dart';
import 'package:json_path/src/selector.dart';

class Union implements Selector {
  const Union(this._elements);

  final Iterable<Selector> _elements;

  @override
  Iterable<Node> apply(Node node) => _elements.expand((e) => e.apply(node));
}
