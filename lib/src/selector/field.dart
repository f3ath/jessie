import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/string/quote.dart';

class Field implements Selector {
  Field(this.name, {this.quotationMark = "'"});

  final String name;
  final String quotationMark;

  @override
  Iterable<JsonPathMatch> read(JsonPathMatch match) {
    final v = match.value;
    if (v is Map && v.containsKey(name)) {
      return [
        JsonPathMatch(
            v[name],
            match.path + '[' + quote(name, quotationMark: quotationMark) + ']',
            match.pointer.append(name))
      ];
    }
    return <JsonPathMatch>[];
  }
}
