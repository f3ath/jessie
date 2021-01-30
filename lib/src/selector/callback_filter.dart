import 'package:json_path/src/filter_not_found.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector.dart';
import 'package:json_path/src/selector/wildcard.dart';

class CallbackFilter implements Selector {
  CallbackFilter(this.name);

  final String name;

  @override
  Iterable<JsonPathMatch> apply(JsonPathMatch match) sync* {
    final filter = match.context.filters[name];
    if (filter == null) {
      throw FilterNotFound('Callback filter "$name" not found');
    }
    yield* const Wildcard().apply(match).where(filter);
  }
}
