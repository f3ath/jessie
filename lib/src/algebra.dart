/// Evaluation rules used in expressions like `$[?(@.foo > 2)]`.
/// Allows users to implement custom evaluation rules to emulate behavior
/// in other programming languages, e.g. in JavaScript.
abstract class Algebra {
  /// A set of rules with strictly typed operations.
  /// Throws [TypeError] when the operation is not applicable to operand types.
  static const Algebra strict = _Strict();

  /// A relaxed set of rules allowing some operations on not fully compatible types.
  /// E.g. `1 < "3"` would return false instead of throwing a [TypeError].
  static const Algebra relaxed = _Relaxed();

  /// True if [a] equals [b].
  bool eq(a, b);

  /// True if [a] is not equal to [b].
  bool ne(a, b);

  /// True if [a] is strictly less than [b].
  bool lt(a, b);

  /// True if [a] is less or equal to [b].
  bool le(a, b);

  /// True if [a] is strictly greater than [b].
  bool gt(a, b);

  /// True if [a] is greater or equal to [b].
  bool ge(a, b);

  /// True if both [a] and [b] are truthy.
  bool and(a, b);

  /// True if either [a] or [b] are truthy.
  bool or(a, b);

  /// Casts the [val] to bool.
  bool isTruthy(val);
}

class _Strict implements Algebra {
  const _Strict();

  @override
  bool isTruthy(val) => val;

  @override
  bool eq(a, b) => a == b;

  @override
  bool ge(a, b) => a >= b;

  @override
  bool gt(a, b) => a > b;

  @override
  bool le(a, b) => a <= b;

  @override
  bool lt(a, b) => a < b;

  @override
  bool ne(a, b) => a != b;

  @override
  bool and(a, b) => isTruthy(a) && isTruthy(b);

  @override
  bool or(a, b) => isTruthy(a) || isTruthy(b);
}

class _Relaxed extends _Strict {
  const _Relaxed();

  @override
  bool isTruthy(val) =>
      val == true ||
      val is List ||
      val is Map ||
      (val is num && val != 0) ||
      (val is String && val.isNotEmpty);

  @override
  bool ge(a, b) =>
      (a is String && b is String && a.compareTo(b) >= 0) ||
      (a is num && b is num && a >= b);

  @override
  bool gt(a, b) =>
      (a is String && b is String && a.compareTo(b) > 0) ||
      (a is num && b is num && a > b);

  @override
  bool le(a, b) =>
      (a is String && b is String && a.compareTo(b) <= 0) ||
      (a is num && b is num && a <= b);

  @override
  bool lt(a, b) =>
      (a is String && b is String && a.compareTo(b) < 0) ||
      (a is num && b is num && a < b);
}
