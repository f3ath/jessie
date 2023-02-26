import 'package:json_path/src/node.dart';
import 'package:json_path/src/selector.dart';
import 'package:json_path/src/selector/wildcard.dart';

class Recursion implements Selector {
  const Recursion();

  @override
  Iterable<Node> apply(Node node) sync* {
    yield node;
    yield* const Wildcard()
        .apply(node)
        .where((e) => e.value is Map || e.value is List)
        .map(apply)
        .expand((_) => _);
  }
}
