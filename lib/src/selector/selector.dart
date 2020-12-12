import 'package:json_path/src/json_path_match.dart';

/// Converts a set of matches into a set of matches
abstract class Selector {
  /// Applies this filter to the [matches]
  Iterable<JsonPathMatch> read(Iterable<JsonPathMatch> matches);

  /// The filter expression as string.
  String expression();

  /// Combines this expression with the [other]
  Selector then(Selector other);

  /// Returns a copy of [json] with all selected values modified using [replacement] function.
  dynamic set(json, Replacement replacement);
}

typedef Replacement<V, T> = V Function(T value);
