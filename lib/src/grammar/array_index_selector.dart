import 'package:json_path/src/grammar/selector.dart';
import 'package:json_path/src/node/node_ext.dart';

Selector arrayIndexSelector(int offset) => (node) sync* {
      final value = node.value;
      if (value is List) {
        final index = offset < 0 ? value.length + offset : offset;
        if (index >= 0 && index < value.length) {
          yield node.valueAt(index);
        }
      }
    };
