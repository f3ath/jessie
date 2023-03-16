import 'package:json_path/src/node/node.dart';

/// An expression applied to a JSON node. For example:
/// `length(@.foo) > 3 && @.bar`. The `@` denotes the current node
/// being processed by JSONPath.
class Expression<T> {
  Expression(this.apply);

  /// Returns the result of applying the expression to the node.
  final T Function(Node) apply;

  /// Creates a new [Expression] by applying the [mapper] function
  /// to the result of this expression.
  Expression<R> map<R>(R Function(T v) mapper) =>
      Expression((node) => mapper(apply(node)));

  /// Creates a new [Expression] from the [other] [Expression] and the
  /// [merger] function. The [merger] function is applied to the values
  /// produced by this an the [other] [Expression].
  Expression<R> merge<R, M>(Expression<M> other, R Function(T a, M b) merger) =>
      Expression((node) => merger(apply(node), other.apply(node)));
}
