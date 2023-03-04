import 'package:json_path/src/node/child_node.dart';
import 'package:json_path/src/node/node.dart';
import 'package:rfc_6901/rfc_6901.dart';

extension NodeExt on Node {
  /// A JSON array element.
  Node valueAt(int index) => ChildNode(value[index], '$path[$index]',
      JsonPointerSegment(index.toString(), pointer), this);

  /// A JSON object child.
  Node child(String key) => ChildNode(value[key], '$path[${_quoted(key)}]',
      JsonPointerSegment(key, pointer), this);

  /// Quotes a [string] using [quote]
  String _quoted(String s) {
    final escaped = s
        .replaceAll(r'/', r'\/')
        .replaceAll(r'\', r'\\')
        .replaceAll('\b', r'\b')
        .replaceAll('\f', r'\f')
        .replaceAll('\n', r'\n')
        .replaceAll('\r', r'\r')
        .replaceAll('\t', r'\t')
        .replaceAll("'", r"\'");
    return "'$escaped'";
  }
}
