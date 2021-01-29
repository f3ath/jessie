import 'package:json_path/json_path.dart';

abstract class Selector {
  /// Applies the selector to the [match]
  Iterable<JsonPathMatch> apply(JsonPathMatch match);
}
