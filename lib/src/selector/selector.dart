import 'package:json_path/src/result.dart';

/// Converts a set of results into a set of results
abstract class Selector {
  /// Applies this filter to the [results]
  Iterable<Result> filter(Iterable<Result> results);

  /// The filter expression as string.
  String expression();

  /// Combines this expression with the [other]
  Selector then(Selector other);

  /// Applies the [mutate] callback to the selected elements in [json].
  /// Returns the modified object.
  dynamic apply(dynamic json, dynamic Function(dynamic _) mutate);
}
