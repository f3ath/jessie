/// Evaluation rules used in expressions like `$[?(@.foo > 2)]`.
/// Allows users to implement custom evaluation rules to emulate behavior
/// in other programming languages, e.g. in JavaScript.
class Algebra {
  const Algebra();

  /// Casts the [val] to bool.
  bool isTruthy(val) => val == true;

  /// True if [a] equals [b].
  bool eq(a, b) =>
      a == b ||
      (a is List &&
          b is List &&
          a.length == b.length &&
          List.generate(a.length, (i) => i).every((i) => eq(a[i], b[i]))) ||
      (a is Map &&
          b is Map &&
          a.keys.length == b.keys.length &&
          a.keys.every((k) => b.containsKey(k) && eq(a[k], b[k])));

  /// True if [a] is greater or equal to [b].
  bool ge(a, b) => gt(a, b) || eq(a, b);

  /// True if [a] is strictly greater than [b].
  bool gt(a, b) => lt(b, a);

  /// True if [a] is less or equal to [b].
  bool le(a, b) => lt(a, b) || eq(a, b);

  /// True if [a] is strictly less than [b].
  bool lt(a, b) =>
      (a is num && b is num && a.compareTo(b) < 0) ||
      (a is String && b is String && a.compareTo(b) < 0);

  /// True if [a] is not equal to [b].
  bool ne(a, b) => !eq(a, b);

  /// True if both [a] and [b] are truthy.
  bool and(a, b) => isTruthy(a) && isTruthy(b);

  /// True if either [a] or [b] are truthy.
  bool or(a, b) => isTruthy(a) || isTruthy(b);
}
