import 'package:json_path/src/pointer/invalid_route.dart';
import 'package:json_path/src/pointer/reference.dart';

/// A JSON Pointer [RFC 6901](https://tools.ietf.org/html/rfc6901).
class JsonPointer {
  const JsonPointer();

  /// An empty JSON Pointer
  static const empty = JsonPointer();

  /// Parses a new JSON Pointer from a string expression.
  /// This method returns a non-writable [JsonPointer] for an empty expression
  /// and [WritableJsonPointer] for a non-empty expression.
  static JsonPointer parse(String expression) {
    if (expression.isEmpty) return empty;
    return parseWritable(expression);
  }

  /// Parses a new writable JSON Pointer from a non-empty string expression.
  /// Throws a [FormatException] if the expression has invalid format.
  static WritableJsonPointer parseWritable(String expression) {
    final errors = _errors(expression);
    if (errors.isNotEmpty) throw FormatException(errors.join(' '));
    return buildWritable(expression.split('/').skip(1).map(_unescape));
  }

  /// Builds a new writable JSON Pointer from a non-empty iterable of segments.
  /// Throws a [ArgumentError] if the iterable is empty.
  static WritableJsonPointer buildWritable(Iterable<String> segments) {
    if (segments.isEmpty) throw ArgumentError('Empty segments');
    return segments.skip(1).fold(empty.append(segments.first),
        (previousValue, element) => previousValue.append(element));
  }

  /// Returns errors found in the [expression].
  /// The expression is valid if no errors are returned.
  static Iterable<String> _errors(String expression) sync* {
    if (!expression.startsWith('/')) {
      yield 'Expression MUST start with "/".';
    }
    if (_danglingTilda.hasMatch(expression)) {
      yield 'Tilda("~") MUST be followed by "0" or "1".';
    }
  }

  static String _unescape(String s) =>
      s.replaceAll('~1', '/').replaceAll('~0', '~');

  static final _danglingTilda = RegExp(r'~[^01]|~$');

  /// Reads the referenced value from the [document].
  /// If no value is referenced, tries to return the result of [orElse].
  /// Otherwise throws [InvalidRoute].
  dynamic read(document, {dynamic Function()? orElse}) => document;

  /// Returns a new writable JSON Pointer by appending a new [reference] at the end.
  WritableJsonPointer append(String reference) =>
      WritableJsonPointer(JsonPointerReference.parse(reference), parent: this);

  @override
  String toString() => '';
}

/// A writable JSON Pointer.
class WritableJsonPointer extends JsonPointer {
  /// Creates a new instance of [WritableJsonPointer] from the [reference].
  /// If [parent] is passed, the [reference] will be appended to it.
  const WritableJsonPointer(this.reference,
      {this.parent = const JsonPointer()});

  /// The rightmost reference in the pointer
  final JsonPointerReference reference;

  /// The parent pointer
  final JsonPointer parent;

  @override
  dynamic read(dynamic document, {dynamic Function()? orElse}) {
    try {
      return reference.read(parent.read(document));
    } on InvalidRoute catch (e) {
      if (orElse != null) return orElse();
      throw _wrapped(e);
    }
  }

  /// Replaces the referenced value in the [document] with a [newValue].
  /// When a non-existing [Map] (JSON Object) key is referred, it will be added to the map.
  /// When a new index in a [List] (JSON Array) is referred, it will be appended to the list.
  /// Otherwise throws [InvalidRoute].
  void write(dynamic document, dynamic newValue) {
    try {
      reference.write(parent.read(document), newValue);
    } on InvalidRoute catch (e) {
      throw _wrapped(e);
    }
  }

  @override
  String toString() => '$parent$reference';

  InvalidRoute _wrapped(InvalidRoute e) => InvalidRoute(
      'No value is referenced by $this. Failed reference: ${e.pointer}');
}
