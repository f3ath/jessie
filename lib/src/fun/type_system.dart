import 'dart:collection';

import 'package:json_path/src/node.dart';

class LogicalType {
  LogicalType(this.asBool);

  final bool asBool;
}

extension LogicalTypeExt on LogicalType {
  LogicalType and(LogicalType other) => LogicalType(asBool && other.asBool);

  LogicalType or(LogicalType other) => LogicalType(asBool || other.asBool);

  LogicalType not() => LogicalType(!asBool);
}

class NodesType with IterableMixin<Node> {
  NodesType(this._nodes);

  final Iterable<Node> _nodes;

  @override
  Iterator<Node> get iterator => _nodes.iterator;

  ValueType get asValue => length == 1 ? Value(single.value) : Nothing();

  LogicalType get asLogical => LogicalType(isNotEmpty);
}

abstract class ValueType<T> {
  /// Returns the value or throws [StateError].
  dynamic get value;
}

class Value<T> implements ValueType<T> {
  Value(this.value);

  @override
  final T value;
}

class Nothing<T> implements ValueType<T> {
  const Nothing();

  @override
  T get value => throw StateError('There is no spoon');
}
