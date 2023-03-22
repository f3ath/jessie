import 'package:json_path/json_path.dart';
import 'package:json_path/src/node.dart';
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

String _segment(Object? e) =>
    e is int ? '[$e]' : "['${_escape(e.toString())}']";

String _escape(String string) => {
      r'/': r'\/',
      r'\': r'\\',
      '\b': r'\b',
      '\f': r'\f',
      '\n': r'\n',
      '\r': r'\r',
      '\t': r'\t',
      "'": r"\'",
    }.entries.fold(string, (s, e) => s.replaceAll(e.key, e.value));
