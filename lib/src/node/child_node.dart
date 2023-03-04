import 'package:json_path/src/node/node.dart';
import 'package:rfc_6901/rfc_6901.dart';

/// A JSON document node.
class ChildNode implements Node {
  ChildNode(this.value, this.path, this.pointer, this.parent);

  @override
  final dynamic value;

  @override
  final String path;

  @override
  final JsonPointer pointer;

  @override
  final Node parent;

  @override
  Node get root => parent.root;
}
