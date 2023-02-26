import 'package:json_path/src/node.dart';
import 'package:json_path/src/selector.dart';

class Wildcard implements Selector {
  const Wildcard();

  @override
  Iterable<Node> apply(Node node) sync* {
    final value = node.value;
    if (value is Map) {
      yield* value.entries.map((e) => node.child(e.key));
    }
    if (value is List) {
      yield* value.asMap().entries.map((e) => node.valueAt(e.key));
    }
  }
}
