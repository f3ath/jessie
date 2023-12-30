import 'package:json_path/fun_sdk.dart';
import 'package:json_path/src/selector.dart';

SingularSelector childSelector(String key) =>
    (node) => SingularNodeList.from(node.child(key));
