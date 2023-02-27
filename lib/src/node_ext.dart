import 'package:json_path/src/child_node.dart';
import 'package:json_path/src/node.dart';
import 'package:json_path/src/string_ext.dart';
import 'package:rfc_6901/rfc_6901.dart';

extension NodeExt on Node {
  /// A JSON array element.
  Node valueAt(int index) => ChildNode(value[index], '$path[$index]',
      JsonPointerSegment(index.toString(), pointer), this);

  /// A JSON object child.
  Node child(String key) => ChildNode(value[key], '$path[${key.quoted()}]',
      JsonPointerSegment(key, pointer), this);
}
