import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/selector.dart';

String singleQuote(String s) => "'" + s.replaceAll("'", r"\'") + "'";

String doubleQuote(String s) => '"' + s.replaceAll('"', r'\"') + '"';

class DotWildcard implements Selector {
  const DotWildcard();

  @override
  Iterable<JsonPathMatch> read(Iterable<JsonPathMatch> matches) =>
      matches.map((m) {
        final v = m.value;
        if (v is Map) return _map(v, m);
        if (v is List) return _map(v.asMap(), m);
        return <JsonPathMatch>[];
      }).expand((_) => _);

  Iterable<JsonPathMatch> _map(Map v, JsonPathMatch m) =>
      v.entries.map((e) => JsonPathMatch(
          e.value,
          m.path + '[' + _quote(e.key) + ']',
          m.pointer.append(e.key.toString())));

  String _quote(key) => (key is int) ? key.toString() : singleQuote(key);
}
