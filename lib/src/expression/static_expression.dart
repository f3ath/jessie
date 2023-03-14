import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/node/node.dart';

/// A special case of [Expression] where the value is known at parse time.
class StaticExpression<T> implements Expression<T> {
  StaticExpression(this.value);

  final T value;

  @override
  T Function(Node p1) get apply => (node) => value;

  @override
  Expression<R> map<R>(R Function(T v) mapper) =>
      StaticExpression(mapper(value));

  @override
  Expression<R> merge<R, M>(Expression<M> other, R Function(T v, M m) merger) {
    if (other is StaticExpression<M>) {
      return StaticExpression(merger(value, other.value));
    }
    return Expression((node) => merger(apply(node), other.apply(node)));
  }
}
