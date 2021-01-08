import 'package:json_path/src/json_path_match.dart';

abstract class Selector {
  /// Applies this filter to the [matches]
  Iterable<JsonPathMatch> read(JsonPathMatch match);
}
