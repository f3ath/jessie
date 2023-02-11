import 'package:rfc_6901/rfc_6901.dart';

abstract class JsonPathMatch {
  /// The matched value
  dynamic get value;

  /// JSONPath to this match
  String get path;

  /// JSON Pointer (RFC 6901) to this match
  JsonPointer get pointer;

  /// The parent match
  JsonPathMatch? get parent;
}
