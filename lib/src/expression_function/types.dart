import 'dart:collection';

import 'package:json_path/src/node.dart';

class LogicalType {
  LogicalType(this.asBool);

  final bool asBool;

  LogicalType and(LogicalType other) => LogicalType(asBool && other.asBool);

  LogicalType or(LogicalType other) => LogicalType(asBool || other.asBool);

  LogicalType not() => LogicalType(!asBool);
}

extension ToLogicalType on bool {
  LogicalType get asLogicalType => LogicalType(this);
}

abstract class ValueType {
  /// True if this is Nothing.
  bool get isNothing;

  /// Returns the value or throws [StateError].
  dynamic get value;
}

abstract class NodesType implements Iterable<Node> {}

class Value implements ValueType {
  Value(this.value);

  @override
  final dynamic value;

  @override
  final isNothing = false;
}

class Nothing implements ValueType {
  const Nothing();

  @override
  final isNothing = true;

  @override
  get value => throw StateError('There is no spoon');
}

class Nodes with IterableMixin<Node> implements NodesType {
  Nodes(this._nodes);

  final Iterable<Node> _nodes;

  @override
  Iterator<Node> get iterator => _nodes.iterator;
}
