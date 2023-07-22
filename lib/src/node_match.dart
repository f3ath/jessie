import 'package:json_path/json_path.dart';
import 'package:json_path/src/node.dart';
import 'package:json_path/src/normalized/index_selector.dart';
import 'package:json_path/src/normalized/name_selector.dart';
import 'package:rfc_6901/rfc_6901.dart';

class NodeMatch implements JsonPathMatch {
  NodeMatch(Node node)
      : value = node.value,
        path = node.path(),
        pointer = node.pointer();

  @override
  final String path;

  @override
  final JsonPointer pointer;

  @override
  final Object? value;
}

extension _NodeExt<T> on Node<T> {
  Iterable<Object> trace() sync* {
    if (key != null) {
      yield* parent!.trace();
      yield key!;
    }
    if (index != null) {
      yield* parent!.trace();
      yield index!;
    }
  }

  JsonPointer pointer() => JsonPointer.build(trace().map((e) => e.toString()));

  String path() => r'$' + trace().map(_segment).join();
}

Object _segment(Object? v) =>
    v is int ? IndexSelector(v) : NameSelector(v.toString());
