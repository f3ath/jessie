import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/quote.dart';

class Wildcard implements Selector {
  const Wildcard();

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
