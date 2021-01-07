import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/quote.dart';
import 'package:json_path/src/selector/selector.dart';

class Field implements Selector {
  Field(this.name, {this.quotationMark = "'"});

  final String name;
  final String quotationMark;

  @override
  Iterable<JsonPathMatch> read(JsonPathMatch match) sync* {
    final v = match.value;
    if (v is Map && v.containsKey(name)) {
      yield JsonPathMatch(
          v[name],
          match.path + '[' + quote(name, quotationMark: quotationMark) + ']',
          match.pointer.append(name));
    }
  }
}
