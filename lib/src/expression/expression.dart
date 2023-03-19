import 'package:json_path/src/node/node.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

/// An expression applicable to a JSON node. For example:
/// `length(@.foo) > 3 && @.bar`. The `@` denotes the current node
/// being processed by JSONPath.
class Expression<T> {
  Expression(this.apply);

  /// Creates an expression from a value.
  static Expression<R> fromValue<R>(R value) => _StaticExpression(value);

  /// Returns the result of applying the expression to the node.
  final T Function(Node) apply;

  /// Returns the value, if it is known upfront.
  Maybe<T> get value => Nothing();

  /// Creates a new [Expression] by applying the [mapper] function
  /// to the result of this expression.
  Expression<R> map<R>(R Function(T v) mapper) =>
      Expression((node) => mapper(apply(node)));

  /// Creates a new [Expression] from the [other] [Expression] and the
  /// [merger] function. The [merger] function is applied to the values
  /// produced by this an the [other] [Expression].
  Expression<R> merge<R, M>(Expression<M> other, R Function(T a, M b) merger) =>
      _merge(this, other, merger);
}

Expression<R> _merge<R, T1, T2>(
        Expression<T1> a, Expression<T2> b, R Function(T1 a, T2 b) merger) =>
    Expression((node) => merger(a.apply(node), b.apply(node)));

/// A special case of [Expression] where the value is known at parse time.
class _StaticExpression<T> implements Expression<T> {
  _StaticExpression(this._value);

  final T _value;

  @override
  T Function(Node p1) get apply => (node) => _value;

  @override
  Maybe<T> get value => Just(_value);

  @override
  Expression<R> map<R>(R Function(T v) mapper) =>
      _StaticExpression(mapper(_value));

  @override
  Expression<R> merge<R, M>(Expression<M> other, R Function(T v, M m) merger) =>
      value
          .merge(other.value, merger)
          .map(Expression.fromValue)
          .orGet(() => _merge(this, other, merger));
}
