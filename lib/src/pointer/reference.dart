import 'package:json_path/src/pointer/invalid_route.dart';

/// JSON Pointer writable reference (anything other than root)
class JsonPointerReference {
  const JsonPointerReference(this._key);

  static JsonPointerReference parse(String expression) =>
      NewElementReference._tryParse(expression) ??
      ArrayIndexReference._tryParse(expression) ??
      JsonPointerReference(expression);

  static String _escape(String s) =>
      s.replaceAll('~', '~0').replaceAll('/', '~1');

  final String _key;

  /// Reads the referenced value from the [document].
  /// If no value is referenced, throws [InvalidRoute].
  dynamic read(document) {
    if (document is Map && document.containsKey(_key)) return document[_key];
    throw InvalidRoute(toString());
  }

  /// Replaces the referenced value in the [document] with a [newValue].
  /// When a non-existing [Map] (JSON Object) key is referred, it will be added to the map.
  /// When a new index in a [List] (JSON Array) is referred, it will be appended to the list.
  /// Otherwise throws [InvalidRoute].
  void write(document, newValue) {
    if (document is Map) {
      document[_key] = newValue;
    } else {
      throw InvalidRoute(toString());
    }
  }

  @override
  String toString() => '/' + _escape(_key);
}

/// A reference to a value in a List or Map
class ArrayIndexReference extends JsonPointerReference {
  ArrayIndexReference(this._index) : super(_index.toString());

  static ArrayIndexReference? _tryParse(String expression) {
    if (_number.hasMatch(expression)) {
      return ArrayIndexReference(int.parse(expression));
    }
  }

  static final _number = RegExp(r'^(0|([1-9][0-9]*))$');

  final int _index;

  @override
  dynamic read(document) {
    if (_applicableTo(document)) {
      return document[_index];
    }
    return super.read(document);
  }

  @override
  void write(node, value) {
    if (_applicableTo(node)) {
      node[_index] = value;
    } else {
      super.write(node, value);
    }
  }

  bool _applicableTo(dynamic document) =>
      document is List && _index >= 0 && _index < document.length;
}

/// A new element in a List
class NewElementReference extends JsonPointerReference {
  const NewElementReference() : super('-');

  static NewElementReference? _tryParse(Object expression) {
    if (expression == '-') return const NewElementReference();
  }

  @override
  void write(document, value) {
    if (document is List) {
      document.add(value);
    } else {
      super.write(document, value);
    }
  }
}
