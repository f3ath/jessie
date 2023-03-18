import 'package:json_path/src/grammar/all_children.dart';
import 'package:json_path/src/node/node.dart';

Iterable<Node> selectAllRecursively(Node node) sync* {
  yield node;
  yield* allChildren(node)
      .where((e) => e.value is Map || e.value is List)
      .expand(selectAllRecursively);
}
