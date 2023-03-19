import 'package:json_path/src/grammar/selector.dart';

Selector arrayIndexSelector(int offset) => (node) sync* {
      final element = node.element(offset);
      if (element != null) yield element;
    };
