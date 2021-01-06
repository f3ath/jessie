import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/union_element.dart';

class QuotedField implements UnionElement {
  QuotedField(this.quoted) : unquoted = unquote(quoted);

  static String unquote(String quoted) => quoted
      .substring(1, quoted.length - 1)
      .replaceAll(r'\' + quoted[0], quoted[0])
      .replaceAll(r'\\', r'\')
      .replaceAll(r'\b', '\b')
      .replaceAll(r'\t', '\t')
      .replaceAll(r'\n', '\n')
      .replaceAll(r'\f', '\f')
      .replaceAll(r'\r', '\r');

  final String quoted;
  final String unquoted;

  @override
  Iterable<JsonPathMatch> read(JsonPathMatch match) {
    final v = match.value;
    if (v is Map && v.containsKey(unquoted)) {
      return [
        JsonPathMatch(v[unquoted], match.path + '[' + quoted + ']',
            match.pointer.append(unquoted))
      ];
    }
    return const <JsonPathMatch>[];
  }
}
