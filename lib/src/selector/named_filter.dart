import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/filter_not_found.dart';
import 'package:json_path/src/selector/selector.dart';

class NamedFilter implements Selector {
  NamedFilter(this.name);

  final String name;

  @override
  Iterable<JsonPathMatch> read(JsonPathMatch match) sync* {
    final filter = match.getFilter(name);
    if (filter == null) {
      throw FilterNotFound('Callback filter "$name" not found');
    }
    if (filter(match)) yield match;
  }
}
