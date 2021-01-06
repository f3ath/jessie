import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/union_element.dart';

class ArrayIndex implements UnionElement {
  ArrayIndex(this.index);

  final int index;

  @override
  Iterable<JsonPathMatch> read(JsonPathMatch match) {
    final v = match.value;
    if (v is List) {
      final normalized = index < 0 ? v.length + index : index;
      if (normalized >= 0 && normalized < v.length) {
        return [
          JsonPathMatch(
              v[normalized],
              match.path + '[' + index.toString() + ']',
              match.pointer.append(normalized.toString()))
        ];
      }
    }
    return const <JsonPathMatch>[];
  }
}
