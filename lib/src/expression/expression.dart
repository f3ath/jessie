import 'package:json_path/src/node/node.dart';

/// An expression applied to a JSON node. For example:
/// `length(@.foo) > 3 && @.bar`. The `@` denotes the current node
/// being processed by JSONPath.
class Expression<T> {
  Expression(this._call);

  final T Function(Node) _call;

  /// Returns the result of applying the expression to the node.
  T of(Node node) => _call(node);

  /// Creates a new [Expression] by applying the [mapper] function
  /// to the result of this expression.
  Expression<R> map<R>(R Function(T v) mapper) =>
      Expression((node) => mapper(of(node)));

  /// Creates a new [Expression] from the [other] [Expression] and the
  /// [merger] function. The [merger] function is applied to the values
  /// produced by this an the [other] [Expression].
  Expression<R> merge<R, M>(
          Expression<M> other, R Function(T self, M other) merger) =>
      Expression((node) => merger(of(node), other.of(node)));
}
