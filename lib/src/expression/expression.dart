import 'package:json_path/src/node/node.dart';

/// An expression applied to a JSON node. For example:
/// `length(@.foo) > 3 && @.bar`. The `@` denotes the current node
/// being processed by JSONPath.
class Expression<T> {
  Expression(this._map);

  final T Function(Node) _map;

  /// Returns the result of applying the expression to the node.
  T applyTo(Node node) => _map(node);

  /// Creates a new [Expression] by applying the [mapper] function
  /// to the value produced by this mapper.
  Expression<R> map<R>(R Function(T v) mapper) =>
      Expression((node) => mapper(applyTo(node)));

  /// Creates a new [Expression] from the [other] [Expression] and the
  /// [mapper] function. The [mapper] function is applied to the values
  /// produced by this an the [other] [Expression].
  Expression<R> flatMap<R, M>(
          Expression<M> other, R Function(T self, M other) mapper) =>
      Expression((node) => mapper(applyTo(node), other.applyTo(node)));
}
