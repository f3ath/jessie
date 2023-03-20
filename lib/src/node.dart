import 'package:json_path/src/grammar/slice_indices.dart';
import 'package:rfc_6901/rfc_6901.dart';

/// A JSON document node.
class Node<T> {
  /// Creates an instance of the root node of the JSON document [value].
  Node(this.value,
      {this.path = r'$',
      JsonPointer? pointer,
      this.parent,
      this.key,
      this.index})
      : pointer = pointer ?? JsonPointer();

  /// Creates an instance of a child node.
  Node._(this.value, this.path, this.pointer, this.parent,
      {this.key, this.index});

  /// The node value.
  final T value;

  /// The Normalized JSONPath to this node.
  final String path;

  /// JSON Pointer (RFC 6901) to this node.
  final JsonPointer pointer;

  /// The parent node.
  final Node? parent;

  /// The root node of the entire document.
  Node get root => parent?.root ?? this;

  /// For a node which is an object child, this is its [key] in the [parent]
  /// node.
  final String? key;

  /// For a node which is an element of an array, this is its [index]
  /// in the [parent] node.
  final int? index;

  /// For a node whose value is an array, returns the slice of
  /// its children.
  Iterable<Node>? slice({int? start, int? stop, int? step}) {
    final v = value;
    if (v is List) {
      return sliceIndices(v.length, start, stop, step ?? 1)
          .map((index) => _element(v, index));
    }
    return null;
  }

  /// Returns the JSON array element at the [offset] if it exists,
  /// otherwise returns null. Negative offsets are supported.
  Node? element(int offset) {
    final v = value;
    if (v is List) {
      final index = offset < 0 ? v.length + offset : offset;
      if (index >= 0 && index < v.length) {
        return _element(v, index);
      }
    }
    return null;
  }

  Node _element(List list, int index) => Node._(list[index], '$path[$index]',
      JsonPointerSegment(index.toString(), pointer), this,
      index: index);

  /// Returns the JSON object child at the [key] if it exists,
  /// otherwise returns null.
  Node? child(String key) {
    final v = value;
    if (v is Map && v.containsKey(key)) {
      return _child(v, key);
    }
    return null;
  }

  Node<dynamic> _child(Map map, String key) => Node._(
      map[key], '$path[${key.quoted}]', JsonPointerSegment(key, pointer), this,
      key: key);

  /// All direct children of the node.
  Iterable<Node> get children sync* {
    final v = value;
    if (v is Map) {
      yield* v.keys.map((key) => _child(v, key));
    }
    if (v is List) {
      yield* v.asMap().keys.map((index) => _element(v, index));
    }
  }

  /// All siblings of the node.
  Iterable<Node> get siblings =>
      parent?.children.where((it) => it != this) ?? [];

  /// All descendants of the node. That is its children,
  /// the children of the children, and so forth.
  Iterable<Node> get descendants sync* {
    for (final child in children) {
      yield child;
      yield* child.descendants;
    }
  }

  @override
  bool operator ==(Object other) =>
      other is Node &&
      other.value == value &&
      other.parent == parent &&
      other.index == index &&
      other.key == key;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Node($value)';
}

extension _StringExt on String {
  String get quoted => "'$escaped'";

  String get escaped => {
        r'/': r'\/',
        r'\': r'\\',
        '\b': r'\b',
        '\f': r'\f',
        '\n': r'\n',
        '\r': r'\r',
        '\t': r'\t',
        "'": r"\'",
      }.entries.fold(this, (s, e) => s.replaceAll(e.key, e.value));
}
