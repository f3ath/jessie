import 'package:json_path/src/node.dart';
import 'package:rfc_6901/rfc_6901.dart';

/// A JSON document node.
class ChildNode implements Node {
  ChildNode(this.value, this.path, this.pointer, this.parent);

  /// The node value
  @override
  final dynamic value;

  /// JSONPath to this node
  @override
  final String path;

  /// JSON Pointer (RFC 6901) to this node
  @override
  final JsonPointer pointer;

  /// The parent node
  @override
  final Node? parent;
}
