import 'package:json_path/src/grammar/select_all.dart';
import 'package:json_path/src/node/node.dart';

Iterable<Node> selectAllRecursively(Node node) sync* {
  yield node;
  yield* selectAll(node)
      .where((e) => e.value is Map || e.value is List)
      .map(selectAllRecursively)
      .expand((_) => _);
}
