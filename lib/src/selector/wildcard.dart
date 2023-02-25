import 'package:json_path/src/node.dart';
import 'package:json_path/src/selector.dart';

class Wildcard implements Selector {
  const Wildcard();

  @override
  Iterable<Node> apply(Node match) sync* {
    final value = match.value;
    if (value is Map) {
      yield* value.entries.map((e) => match.child(e.key));
    }
    if (value is List) {
      yield* value.asMap().entries.map((e) => match.at(e.key));
    }
  }
}
