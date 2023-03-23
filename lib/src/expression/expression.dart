import 'package:json_path/src/node.dart';

/// An expression applicable to a JSON node. For example:
/// `length(@.foo) > 3 && @.bar`. The `@` denotes the current node
/// being processed by JSONPath.
class Expression<T extends Object> {
  Expression(this.call);

  /// Returns the result of applying the expression to the node.
  final T Function(Node) call;

  /// Creates a new [Expression] by applying the [mapper] function
  /// to the result of this expression.
  Expression<R> map<R extends Object>(R Function(T v) mapper) =>
      Expression((node) => mapper(call(node)));

  /// Creates a new [Expression] from the [other] [Expression] and the
  /// [merger] function. The [merger] function is applied to the values
  /// produced by this an the [other] [Expression].
  Expression<R> merge<R extends Object, M extends Object>(
          Expression<M> other, R Function(T a, M b) merger) =>
      Expression((node) => merger(call(node), other.call(node)));
}
