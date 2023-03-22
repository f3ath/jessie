import 'package:json_path/src/selector/selector.dart';

SelectorFun arrayIndexSelector(int offset) => (node) sync* {
      final element = node.element(offset);
      if (element != null) yield element;
    };
