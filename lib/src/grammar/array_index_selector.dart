import 'package:json_path/fun_sdk.dart';
import 'package:json_path/src/selector.dart';

SingularSelector arrayIndexSelector(int offset) =>
    (node) => SingularNodeList.from(node.element(offset));
