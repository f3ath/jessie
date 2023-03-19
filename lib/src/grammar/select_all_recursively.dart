import 'package:json_path/src/node/node.dart';

Iterable<Node> selectAllRecursively(Node node) sync* {
  yield node;
  yield* node.descendants;
}
