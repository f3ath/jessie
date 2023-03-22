import 'package:rfc_6901/rfc_6901.dart';

abstract class JsonPathMatch {
  /// The matched value.
  Object? get value;

  /// The normalized JSONPath to this node.
  String get path;

  /// JSON Pointer (RFC 6901) to this node.
  JsonPointer get pointer;
}
