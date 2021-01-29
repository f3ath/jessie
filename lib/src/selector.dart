import 'package:json_path/json_path.dart';
import 'package:json_path/src/child_match.dart';

abstract class Selector {
  /// Applies this filter to the [match]
  Iterable<JsonPathMatch> read(JsonPathMatch match);
}
