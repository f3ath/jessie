import 'package:json_path/fun_sdk.dart';

/// Returns all siblings of the given nodes.
class Siblings implements Fun1<Nodes, Nodes> {
  @override
  final name = 'siblings';

  @override
  Nodes call(Nodes nodes) => nodes
      .expand((node) => node.parent?.children.where((it) => node != it) ?? []);
}
