import 'package:json_path/fun_sdk.dart';

/// Returns all siblings of the given nodes.
class SiblingsFun implements Fun1<Nodes, Nodes> {
  @override
  final name = 'siblings';

  @override
  Nodes apply(Nodes nodes) => nodes.expand((it) => it.siblings);
}
