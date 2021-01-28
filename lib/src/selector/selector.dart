import 'package:json_path/src/json_path_match.dart';

abstract class Selector {
  /// Applies this filter to the [match]
  Iterable<JsonPathMatch> read(JsonPathMatch match);
}
