import 'dart:collection';

import 'package:json_path/src/fun/types/logical.dart';
import 'package:json_path/src/fun/types/nothing.dart';
import 'package:json_path/src/fun/types/value.dart';
import 'package:json_path/src/node.dart';

/// Nodes type.
class Nodes with IterableMixin<Node> {
  Nodes(this._nodes);

  final Iterable<Node> _nodes;

  @override
  Iterator<Node> get iterator => _nodes.iterator;

  Value get asValue => length == 1 ? Value(single.value) : Nothing();

  Logical get asLogical => Logical(isNotEmpty);
}
