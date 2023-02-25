import 'package:json_path/src/node.dart';
import 'package:json_path/src/selector.dart';

class Field implements Selector {
  Field(this.name);

  final String name;

  @override
  Iterable<Node> apply(Node match) sync* {
    final value = match.value;
    if (value is Map && value.containsKey(name)) {
      yield match.child(name);
    }
  }
}
