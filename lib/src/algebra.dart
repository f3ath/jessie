import 'package:json_path/src/expression_function/count_function.dart';
import 'package:json_path/src/expression_function/function_call.dart';
import 'package:json_path/src/expression_function/length_function.dart';
import 'package:json_path/src/expression_function/match_function.dart';
import 'package:json_path/src/expression_function/types.dart';
import 'package:json_path/src/node.dart';
import 'package:json_path/src/node_mapper.dart';

/// Evaluation rules used in expressions like `$[?(@.foo > 2)]`.
/// Allows users to implement custom evaluation rules to diverge from the
/// standard.
class Algebra {
  const Algebra();

  /// Casts the [val] to bool.
  bool isTruthy(val) {
    if (val is LogicalType) return val.asBool;
    if (val is Iterable<Node>) return val.isNotEmpty; // TODO: refactor
    return val == true;
  }

  /// True if [a] equals [b].
  bool eq(a, b) {
    if (a is Iterable<Node> && b is Iterable<Node> && a.isEmpty && b.isEmpty) {
      return true;
    }
    if (a is Iterable<Node> && a.length != 1 ||
        b is Iterable<Node> && b.length != 1) {
      return false;
    }
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

  /// Returns an instance of expression function with the given arguments.
  NodeMapper makeFunction(FunctionCall call) {
    if (call.name == 'length') return LengthFunction.fromArgs(call.args).apply;
    if (call.name == 'count') return CountFunction.fromArgs(call.args).apply;
    throw FormatException('Undefined function "$call"');
  }

  /// Returns an instance of predicate expression function with the given arguments.
  NodeMapper<LogicalType> makePredicateFunction(FunctionCall call) {
    if (call.name == 'match') {
      return MatchFunction.fromArgs(call.args, matchSubstring: false).apply;
    }
    if (call.name == 'search') {
      return MatchFunction.fromArgs(call.args, matchSubstring: true).apply;
    }
    throw FormatException('Undefined predicate function "$call"');
  }

  bool _deepEq(a, b) =>
      a == b ||
      (a is List &&
          b is List &&
          a.length == b.length &&
          List.generate(a.length, (i) => i).every((i) => eq(a[i], b[i]))) ||
      (a is Map &&
          b is Map &&
          a.keys.length == b.keys.length &&
          a.keys.every((k) => b.containsKey(k) && eq(a[k], b[k])));

  _valOf(x) {
    if (x is Value) return x.value;
    if (x is Iterable<Node>) {
      if (x.length == 1) return x.single.value;
      return Nothing();
    }
    return x;
  }
}
