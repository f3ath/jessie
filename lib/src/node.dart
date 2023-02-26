import 'package:json_path/src/string_ext.dart';
import 'package:rfc_6901/rfc_6901.dart';

/// A JSON document node.
class Node {
  Node(this.value, {String? path, JsonPointerSegment? pointer, this.parent})
      : path = path ?? r'$',
        pointer = pointer ?? JsonPointer();

  /// The node value
  final dynamic value;

  /// JSONPath to this node
  final String path;

  /// JSON Pointer (RFC 6901) to this node
  final JsonPointer pointer;

  /// The parent node
  final Node? parent;

  /// A JSON array element.
  Node valueAt(int index) => Node(value[index],
      parent: this,
      path: '$path[$index]',
      pointer: JsonPointerSegment(index.toString(), pointer));

  /// A JSON object child.
  Node child(String key) => Node(value[key],
      parent: this,
      path: '$path[${key.quoted()}]',
      pointer: JsonPointerSegment(key, pointer));
}
