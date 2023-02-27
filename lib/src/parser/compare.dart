import 'package:json_path/src/parser/fun/type_system.dart';

/// True if [a] equals [b].
bool _eq(a, b) {
  if (a is Nodes && a.isEmpty) {
    return b is Nodes && b.isEmpty;
  }
  if (b is Nodes && b.isEmpty) {
    return a is Nodes && a.isEmpty;
  }
  if (a is Nodes && a.asValue is Nothing) return false;
  if (b is Nodes && b.asValue is Nothing) return false;

  return _deepEq(_valOf(a), _valOf(b));
}

/// True if [a] is greater or equal to [b].
bool _ge(a, b) => _gt(a, b) || _eq(a, b);

/// True if [a] is strictly greater than [b].
bool _gt(a, b) => _lt(b, a);

/// True if [a] is less or equal to [b].
bool _le(a, b) => _lt(a, b) || _eq(a, b);

/// True if [a] is strictly less than [b].
bool _lt(a, b) => _ltRaw(_valOf(a), _valOf(b));

bool _ltRaw(a, b) =>
    (a is num && b is num && a.compareTo(b) < 0) ||
    (a is String && b is String && a.compareTo(b) < 0);

/// True if [a] is not equal to [b].
bool _ne(a, b) => !_eq(a, b);

/// Deep equality of primitives, lists, maps.
bool _deepEq(a, b) =>
    ((a == null || a is num || a is bool || a is String) && a == b) ||
    (a is List &&
        b is List &&
        a.length == b.length &&
        List.generate(a.length, (i) => i).every((i) => _eq(a[i], b[i]))) ||
    (a is Map &&
        b is Map &&
        a.keys.length == b.keys.length &&
        a.keys.every((k) => b.containsKey(k) && _deepEq(a[k], b[k])));

_valOf(x) {
  if (x is Value) return x.value;
  if (x is Nodes) return _valOf(x.asValue);
  return x;
}

final _ops = <String, bool Function(dynamic, dynamic)>{
  '==': _eq,
  '!=': _ne,
  '<=': _le,
  '>=': _ge,
  '<': _lt,
  '>': _gt,
};

bool compare(String op, dynamic a, dynamic b) =>
    (_ops[op] ?? (throw StateError('Invalid operation "$op"')))(a, b);
