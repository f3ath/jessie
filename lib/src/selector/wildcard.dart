import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/single_quote.dart';
import 'package:json_path/src/selector/union_element.dart';

class Wildcard implements UnionElement {
  const Wildcard({this.quote = singleQuote});

  final String Function(String s) quote;

  @override
  Iterable<JsonPathMatch> read(JsonPathMatch match) {
    final v = match.value;
    if (v is Map) return _map(v, match);
    if (v is List) return _map(v.asMap(), match);
    return <JsonPathMatch>[];
  }

  Iterable<JsonPathMatch> _map(Map v, JsonPathMatch m) =>
      v.entries.map((e) => JsonPathMatch(
          e.value,
          m.path + '[' + _quote(e.key) + ']',
          m.pointer.append(e.key.toString())));

  String _quote(key) => (key is int) ? key.toString() : quote(key);
}
