import 'package:json_path/src/expression/expression.dart';

/// A special case of [Expression] where the value is known at parse time.
class StaticExpression<T extends Object> extends Expression<T> {
  StaticExpression(this.value) : super((_) => value);

  final T value;

  @override
  Expression<R> map<R extends Object>(R Function(T v) mapper) =>
      StaticExpression(mapper(value));

  @override
  Expression<R> merge<R extends Object, M extends Object>(
          Expression<M> other, R Function(T v, M m) merger) =>
      other is StaticExpression<M>
          ? StaticExpression(merger(value, other.value))
          : super.merge(other, merger);
}
