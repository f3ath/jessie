import 'package:json_path/src/fun/types/logical.dart';
import 'package:json_path/src/fun/types/nothing.dart';
import 'package:json_path/src/fun/types/value.dart';

/// True if [a] equals [b].
bool _eq(Value a, Value b) =>
    a.flatMap(b, _eqRaw).orElse(() => a is Nothing && b is Nothing);

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
bool _ge(Value a, Value b) => _gt(a, b) || _eq(a, b);

/// True if [a] is strictly greater than [b].
bool _gt(Value a, Value b) => _lt(b, a);

/// True if [a] is less or equal to [b].
bool _le(Value a, Value b) => _lt(a, b) || _eq(a, b);

/// True if [a] is strictly less than [b].
bool _lt(Value a, Value b) => a.flatMap(b, _ltRaw).orElse(() => false);

bool _ltRaw(a, b) =>
    (a is num && b is num && a.compareTo(b) < 0) ||
    (a is String && b is String && a.compareTo(b) < 0);

/// True if [a] is not equal to [b].
bool _ne(Value a, Value b) => !_eq(a, b);

const _operations = <String, bool Function(Value, Value)>{
  '==': _eq,
  '!=': _ne,
  '<=': _le,
  '>=': _ge,
  '<': _lt,
  '>': _gt,
};

Logical compare(String operation, Value a, Value b) =>
    Logical((_operations[operation] ??
        (throw StateError('Invalid operation "$operation"')))(a, b));
