import 'dart:collection';

import 'package:json_path/src/node.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

/// Nodes type.
class Nodes with IterableMixin<Node> {
  Nodes(this._nodes);

  final Iterable<Node> _nodes;

  @override
  Iterator<Node> get iterator => _nodes.iterator;

  Maybe get asValue => length == 1 ? Just(single.value) : Nothing();

  bool get asBool => isNotEmpty;
}
