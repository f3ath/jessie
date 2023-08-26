import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:petitparser/petitparser.dart';

/// True if [a] equals [b].
bool _eq(Maybe a, Maybe b) =>
    a.merge(b, _eqRaw).orGet(() => a is Nothing && b is Nothing);

/// Deep equality of primitives, lists, maps.
bool _eqRaw(a, b) =>
    (a == b) ||
    (a is List &&
        b is List &&
        a.length == b.length &&
        List.generate(a.length, (i) => _eqRaw(a[i], b[i])).every((i) => i)) ||
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
bool _lt(Maybe a, Maybe b) => a
    .merge(
        b,
        (x, y) =>
            (x is num && y is num && x < y) ||
            (x is String && y is String && x.compareTo(y) < 0))
    .or(false);

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

bool compare(String op, Maybe a, Maybe b) =>
    (_operations[op] ?? (throw StateError('Invalid operation "$op"')))(a, b);

final cmpOperator = _operations.keys.map(string).toChoiceParser().trim();
