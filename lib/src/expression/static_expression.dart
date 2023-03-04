import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/node/node.dart';

/// A special case of [Expression] where the value is known at parse time.
class StaticExpression<T> implements Expression<T> {
  StaticExpression(this.value);

  final T value;

  @override
  T applyTo(Node node) => value;

  @override
  Expression<R> map<R>(R Function(T v) mapper) =>
      StaticExpression(mapper(value));

  @override
  Expression<R> flatMap<R, M>(Expression<M> m, R Function(T v, M m) mapper) {
    if (m is StaticExpression<M>) {
      return StaticExpression(mapper(value, m.value));
    }
    return Expression((node) => mapper(value, m.applyTo(node)));
  }
}
