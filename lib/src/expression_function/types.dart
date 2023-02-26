import 'dart:collection';

import 'package:json_path/src/node.dart';

class LogicalType {
  LogicalType(this.asBool);

  final bool asBool;
}

abstract class ValueType {
  /// True if this is Nothing.
  bool get isNothing;

  /// Returns the value or throws [StateError].
  dynamic get value;
}

abstract class NodesType implements Iterable<Node>, LogicalType, ValueType {}

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
  Nodes(this._nodes)
      : asBool = _nodes.isNotEmpty,
        isNothing = _nodes.length != 1;

  final Iterable<Node> _nodes;

  @override
  final bool asBool;

  @override
  final bool isNothing;

  @override
  get value => _nodes.single.value;

  @override
  Iterator<Node> get iterator => _nodes.iterator;
}
