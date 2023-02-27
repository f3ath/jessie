import 'package:json_path/src/fun/type_system.dart';

/// True if [a] equals [b].
bool _eq(ValueType a, ValueType b) {
  if (a is Nothing) return b is Nothing;
  if (b is Nothing) return a is Nothing;
  return _eqRaw(a.value, b.value);
}

/// Deep equality of primitives, lists, maps.
bool _eqRaw(a, b) =>
    ((a == null || a is num || a is bool || a is String) && a == b) ||
    (a is List &&
        b is List &&
        a.length == b.length &&
        List.generate(a.length, (i) => i).every((i) => _eq(a[i], b[i]))) ||
    (a is Map &&
        b is Map &&
        a.keys.length == b.keys.length &&
        a.keys.every((k) => b.containsKey(k) && _eqRaw(a[k], b[k])));

/// True if [a] is greater or equal to [b].
bool _ge(ValueType a, ValueType b) => _gt(a, b) || _eq(a, b);

/// True if [a] is strictly greater than [b].
bool _gt(ValueType a, ValueType b) => _lt(b, a);

/// True if [a] is less or equal to [b].
bool _le(ValueType a, ValueType b) => _lt(a, b) || _eq(a, b);

/// True if [a] is strictly less than [b].
bool _lt(ValueType a, ValueType b) =>
    a is! Nothing && b is! Nothing && _ltRaw(a.value, b.value);

bool _ltRaw(a, b) =>
    (a is num && b is num && a.compareTo(b) < 0) ||
    (a is String && b is String && a.compareTo(b) < 0);

/// True if [a] is not equal to [b].
bool _ne(ValueType a, ValueType b) => !_eq(a, b);

const _operations = <String, bool Function(ValueType, ValueType)>{
  '==': _eq,
  '!=': _ne,
  '<=': _le,
  '>=': _ge,
  '<': _lt,
  '>': _gt,
};

LogicalType compare(String operation, ValueType a, ValueType b) =>
    LogicalType((_operations[operation] ??
        (throw StateError('Invalid operation "$operation"')))(a, b));
