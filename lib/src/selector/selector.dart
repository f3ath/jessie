import 'package:jessie/src/result.dart';
import 'package:jessie/src/selector/all_values.dart';
import 'package:jessie/src/selector/recursive.dart';

/// Converts a set of results into a set of results
abstract class Selector {
  const Selector();

  /// Applies this filter to the [results]
  Iterable<Result> call(Iterable<Result> results);

  /// The filter expression as string
  String get expression;

  @override
  String toString() => expression;

  /// Combines this expression with the [other]
  Selector then(Selector other) => Combine(this, other);
}

/// Combines two selectors together
class Combine extends Selector {
  Combine(this.left, this.right);

  /// Returns the rightmost selector in a chain
  static Selector rightmost(Selector s) =>
      (s is Combine) ? rightmost(s.right) : s;

  final Selector left;

  final Selector right;

  @override
  Iterable<Result> call(Iterable<Result> results) => right(left(results));

  @override
  String get expression {
    /// Special case for the `*` element.
    final actualLeft = rightmost(left);
    final glue = (right is AllValues && (actualLeft is! Recursive)) ? '.' : '';
    return '$left$glue$right';
  }
}
