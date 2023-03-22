import 'package:json_path/src/node.dart';

Iterable<Node> selectAllRecursively(Node node) sync* {
  yield node;
  yield* node.children.expand(selectAllRecursively);
}
