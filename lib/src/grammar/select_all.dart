import 'package:json_path/src/node/node.dart';
import 'package:json_path/src/node/node_ext.dart';

Iterable<Node> selectAll(Node node) sync* {
  final value = node.value;
  if (value is Map) {
    yield* value.entries.map((e) => node.child(e.key));
  }
  if (value is List) {
    yield* value.asMap().entries.map((e) => node.valueAt(e.key));
  }
}
