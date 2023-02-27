import 'package:json_path/src/node.dart';
import 'package:rfc_6901/rfc_6901.dart';

/// A JSON document node.
class RootNode implements Node {
  RootNode(this.value);

  /// The node value
  @override
  final dynamic value;

  /// JSONPath to this node
  @override
  final path = r'$';

  /// JSON Pointer (RFC 6901) to this node
  @override
  final pointer = JsonPointer();

  /// The parent node
  @override
  final parent = null;
}

