import 'package:json_path/src/node.dart';

class LogicalType {
  LogicalType(this.asBool);

  final bool asBool;
}

abstract class ValueType {}

abstract class NodesType {}

class Value implements ValueType {
  Value(this.value);

  final dynamic value;
}

class Nothing implements LogicalType, ValueType {
  const Nothing();

  @override
  final asBool = false;
}

class Nodes implements ValueType, LogicalType {
  Nodes(this._nodes) : asBool = _nodes.isNotEmpty;

  final Iterable<Node> _nodes;

  @override
  final bool asBool;
}
