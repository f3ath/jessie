import 'package:json_path/src/node/child_node.dart';
import 'package:json_path/src/node/node.dart';
import 'package:rfc_6901/rfc_6901.dart';

extension NodeExt on Node {
  /// A JSON array element.
  Node valueAt(int index) => ChildNode(value[index], '$path[$index]',
      JsonPointerSegment(index.toString(), pointer), this);

  /// A JSON object child.
  Node child(String key) => ChildNode(value[key], '$path[${key.quoted}]',
      JsonPointerSegment(key, pointer), this);
}

extension StringExt on String {
  String get quoted => "'$escaped'";

  String get escaped => {
        r'/': r'\/',
        r'\': r'\\',
        '\b': r'\b',
        '\f': r'\f',
        '\n': r'\n',
        '\r': r'\r',
        '\t': r'\t',
        "'": r"\'",
      }.entries.fold(this, (s, e) => s.replaceAll(e.key, e.value));
}
