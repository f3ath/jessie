import 'package:json_path/src/result.dart';

/// Converts a set of results into a set of results
abstract class Selector {
  /// Applies this filter to the [results]
  Iterable<Result> filter(Iterable<Result> results);

  /// The filter expression as string.
  /// The [previous] selector must be provided if being followed by this
  String expression([Selector previous]);

  /// Combines this expression with the [other]
  Selector then(Selector other);
}
