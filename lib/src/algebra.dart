import 'package:json_path/src/match_set.dart';

/// Evaluation rules used in expressions like `$[?(@.foo > 2)]`.
/// Allows users to implement custom evaluation rules to diverge from the
/// standard.
class Algebra {
  const Algebra();

  /// Casts the [val] to bool.
  bool isTruthy(val) => val is MatchSet ? val.isNotEmpty : (val == true);

  /// True if [a] equals [b].
  bool eq(a, b) {
    if (_isEmpty(a) && _isEmpty(b)) return true;
    if (_isNotSingular(a) || _isNotSingular(b)) return false;
    return _deepEq(_valOf(a), _valOf(b));
  }

  /// True if [a] is greater or equal to [b].
  bool ge(a, b) => gt(a, b) || eq(a, b);

  /// True if [a] is strictly greater than [b].
  bool gt(a, b) => lt(b, a);

  /// True if [a] is less or equal to [b].
  bool le(a, b) => lt(a, b) || eq(a, b);

  /// True if [a] is strictly less than [b].
  bool lt(a, b) => _lt(_valOf(a), _valOf(b));

  bool _lt(x, y) =>
      (x is num && y is num && x.compareTo(y) < 0) ||
      (x is String && y is String && x.compareTo(y) < 0);

  /// True if [a] is not equal to [b].
  bool ne(a, b) => !eq(a, b);

  /// True if both [a] and [b] are truthy.
  bool and(a, b) => isTruthy(a) && isTruthy(b);

  /// True if either [a] or [b] are truthy.
  bool or(a, b) => isTruthy(a) || isTruthy(b);

  /// True if a is false.
  bool not(a) => !isTruthy(a);

  fun(String name, List args) {
    return MatchSet([]);
  }

  bool _deepEq(x, y) =>
      x == y ||
      (x is List &&
          y is List &&
          x.length == y.length &&
          List.generate(x.length, (i) => i)
              .every((i) => _deepEq(x[i], y[i]))) ||
      (x is Map &&
          y is Map &&
          x.keys.length == y.keys.length &&
          x.keys.every((k) => y.containsKey(k) && _deepEq(x[k], y[k])));

  bool _isEmpty(set) => set is MatchSet && set.isEmpty;

  bool _isNotSingular(set) => set is MatchSet && !set.isSingular;

  _valOf(x) => (x is MatchSet && x.isSingular) ? x.value : x;
}
