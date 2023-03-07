import 'package:maybe_just_nothing/maybe_just_nothing.dart';

/// True if [a] equals [b].
bool _eq(Maybe a, Maybe b) =>
    a.merge(b, _eqRaw).orGet(() => a is Nothing && b is Nothing);

/// Deep equality of primitives, lists, maps.
bool _eqRaw(a, b) =>
    (/*(a == null || a is num || a is bool || a is String) && */a == b) ||
    (a is List &&
        b is List &&
        a.length == b.length &&
        List.generate(a.length, (i) => i).every((i) => _eqRaw(a[i], b[i]))) ||
    (a is Map &&
        b is Map &&
        a.keys.length == b.keys.length &&
        a.keys.every((k) => b.containsKey(k) && _eqRaw(a[k], b[k])));

/// True if [a] is greater or equal to [b].
bool _ge(Maybe a, Maybe b) => _gt(a, b) || _eq(a, b);

/// True if [a] is strictly greater than [b].
bool _gt(Maybe a, Maybe b) => _lt(b, a);

/// True if [a] is less or equal to [b].
bool _le(Maybe a, Maybe b) => _lt(a, b) || _eq(a, b);

/// True if [a] is strictly less than [b].
bool _lt(Maybe a, Maybe b) => a.merge(b, _ltRaw).or(false);

bool _ltRaw(a, b) =>
    (a is num && b is num && a.compareTo(b) < 0) ||
    (a is String && b is String && a.compareTo(b) < 0);

/// True if [a] is not equal to [b].
bool _ne(Maybe a, Maybe b) => !_eq(a, b);

const _operations = <String, bool Function(Maybe, Maybe)>{
  '==': _eq,
  '!=': _ne,
  '<=': _le,
  '>=': _ge,
  '<': _lt,
  '>': _gt,
};

bool compare(String operation, Maybe a, Maybe b) => (_operations[operation] ??
    (throw StateError('Invalid operation "$operation"')))(a, b);
