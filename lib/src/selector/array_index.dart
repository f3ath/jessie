import 'package:json_path/src/node.dart';
import 'package:json_path/src/selector.dart';

class ArrayIndex implements Selector {
  ArrayIndex(this.offset);

  final int offset;

  @override
  Iterable<Node> apply(Node node) sync* {
    final value = node.value;
    if (value is List) {
      final index = offset < 0 ? value.length + offset : offset;
      if (index >= 0 && index < value.length) {
        yield node.valueAt(index);
      }
    }
  }
}
