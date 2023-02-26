import 'package:json_path/src/node.dart';
import 'package:json_path/src/selector.dart';

class Field implements Selector {
  Field(this.name);

  final String name;

  @override
  Iterable<Node> apply(Node node) sync* {
    final value = node.value;
    if (value is Map && value.containsKey(name)) {
      yield node.child(name);
    }
  }
}
