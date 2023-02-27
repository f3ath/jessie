import 'package:json_path/src/expression_function/count_fun.dart';
import 'package:json_path/src/expression_function/fun_call.dart';
import 'package:json_path/src/expression_function/fun_factory.dart';
import 'package:json_path/src/expression_function/length_fun.dart';
import 'package:json_path/src/expression_function/match_fun.dart';
import 'package:json_path/src/expression_function/types.dart';
import 'package:json_path/src/types/node_mapper.dart';
import 'package:json_path/src/types/node_test.dart';

/// Evaluation rules used in expressions like `$[?(@.foo > 2)]`.
/// Allows users to implement custom evaluation rules to diverge from the
/// standard.
class Algebra {
   Algebra();

  LogicalType test(String op, dynamic a, dynamic b) {
    final ops = <String, bool Function(dynamic, dynamic)>{
      '==': eq,
      '!=': ne,
      '<=': le,
      '>=': ge,
      '<': lt,
      '>': gt,
    };
    final operation = ops[op] ?? (throw StateError('Invalid operation "$op"'));
    return LogicalType(operation(a, b));
  }

  /// True if [a] equals [b].
  bool eq(a, b) {
    if (a is Nodes && b is Nodes && a.isEmpty && b.isEmpty) {
      return true;
    }
    if (a is Nodes && a.asValue.isNothing ||
        b is Nodes && b.asValue.isNothing) {
      return false;
    }
    return _eq(_valOf(a), _valOf(b));
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

  final fact = <FunFactory>[
    LengthFunFactory(),
    CountFunFactory(),
    MatchFunFactory(),
    SearchFunFactory(),
  ];

  /// Returns an instance of expression function with the given arguments.
  NodeMapper makeFun(FunCall call) {
    for (final f in fact) {
      if (f.name == call.name && f is! FunFactory<LogicalType>) {
        try {
          return f.makeFun(call.args);
        } on Exception {
          continue;
        }
      }
    }
    throw Exception();
  }

  /// Returns an instance of test function with the given arguments.
  NodeTest makeTestFun(FunCall call) {
    for (final f in fact) {
      if (f.name == call.name && f is FunFactory<LogicalType>) {
        try {
          return f.makeFun(call.args);
        } on Exception {
          continue;
        }
      }
    }
    throw Exception();
  }

  /// Deep equality of primitives, lists, maps.
  bool _eq(a, b) =>
      a == b ||
      (a is List &&
          b is List &&
          a.length == b.length &&
          List.generate(a.length, (i) => i).every((i) => eq(a[i], b[i]))) ||
      (a is Map &&
          b is Map &&
          a.keys.length == b.keys.length &&
          a.keys.every((k) => b.containsKey(k) && _eq(a[k], b[k])));

  _valOf(x) {
    if (x is Value) return x.value;
    if (x is Nodes) {
      if (x.length == 1) return x.single.value;
      return Nothing();
    }
    return x;
  }
}
