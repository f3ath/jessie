import 'package:rfc_6901/rfc_6901.dart';

/// A JSON document node.
abstract class Node {
  /// The node value.
  dynamic get value;

  /// JSONPath to this node.
  String get path;

  /// JSON Pointer (RFC 6901) to this node
  JsonPointer get pointer;

  /// The parent node
  Node? get parent;

  /// The root node of the document.
  Node get root;
}
