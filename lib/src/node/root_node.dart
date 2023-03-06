import 'package:json_path/src/node/node.dart';
import 'package:rfc_6901/rfc_6901.dart';

/// A JSON document node.
class RootNode<T> implements Node<T> {
  RootNode(this.value);

  @override
  final T value;

  @override
  final path = r'$';

  @override
  final pointer = JsonPointer();

  @override
  final parent = null;

  @override
  Node get root => this;
}
