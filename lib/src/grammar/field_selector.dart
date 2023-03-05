import 'package:json_path/src/grammar/node_selector.dart';
import 'package:json_path/src/node/node_ext.dart';

NodeSelector fieldSelector(String name) => (node) sync* {
      final value = node.value;
      if (value is Map && value.containsKey(name)) {
        yield node.child(name);
      }
    };
