import 'package:json_path/src/selector.dart';

Selector childSelector(String key) => (node) sync* {
      final child = node.child(key);
      if (child != null) yield child;
    };
