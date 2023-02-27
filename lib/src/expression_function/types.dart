import 'dart:collection';

import 'package:json_path/src/node.dart';

/// Anything that can be passed to a function.
abstract class FunArgType {
  ValueType get asValue;
}

/// Anything that converts to [LogicalType].
abstract class LogicalCompatible {
  LogicalType get asLogical;
}

class LogicalType implements LogicalCompatible {
  LogicalType(this.asBool);

  final bool asBool;

  LogicalType and(LogicalType other) => LogicalType(asBool && other.asBool);

  LogicalType or(LogicalType other) => LogicalType(asBool || other.asBool);

  LogicalType not() => LogicalType(!asBool);

  @override
  LogicalType get asLogical => this;
}

abstract class ValueType<T> implements FunArgType {
  /// True if this is Nothing.
  bool get isNothing;

  /// Returns the value or throws [StateError].
  dynamic get value;
}

abstract class NodesType
    implements Iterable<Node>, FunArgType, LogicalCompatible {}

class Value<T> implements ValueType<T> {
  Value(this.value);

  @override
  final T value;

  @override
  final isNothing = false;

  @override
  ValueType get asValue => this;
}

class Nothing<T> implements ValueType<T> {
  const Nothing();

  @override
  final isNothing = true;

  @override
  T get value => throw StateError('There is no spoon');

  @override
  ValueType get asValue => this;
}

class Nodes with IterableMixin<Node> implements NodesType {
  Nodes(this._nodes);

  final Iterable<Node> _nodes;

  @override
  Iterator<Node> get iterator => _nodes.iterator;

  @override
  ValueType get asValue => length == 1 ? Value(single.value) : Nothing();

  @override
  LogicalType get asLogical => LogicalType(isNotEmpty);
}
