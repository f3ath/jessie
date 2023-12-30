import 'package:json_path/fun_sdk.dart';

/// Returns all siblings of the given nodes.
class Siblings implements Fun1<NodeList, NodeList> {
  const Siblings();

  @override
  final name = 'siblings';

  @override
  NodeList call(NodeList nodes) => nodes
      .expand((node) => node.parent?.children.where((it) => node != it) ?? []);
}
