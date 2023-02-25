import 'package:json_path/src/node.dart';
import 'package:json_path/src/selector.dart';
import 'package:json_path/src/selector/wildcard.dart';

class Recursion implements Selector {
  const Recursion();

  @override
  Iterable<Node> apply(Node match) sync* {
    yield match;
    yield* const Wildcard()
        .apply(match)
        .where((e) => e.value is Map || e.value is List)
        .map(apply)
        .expand((_) => _);
  }
}
