import 'package:json_path/fun_sdk.dart';
import 'package:json_path/src/selector.dart';

SingularSelector childSelector(String key) {
  if (key.runes.any(
    (r) => r < 0 || r > 0x10FFFF || (r >= 0xD800 && r <= 0xDFFF),
  )) {
    throw const FormatException('Invalid UTF code units in childSelector.');
  }
  return (node) => SingularNodeList.from(node.child(key));
}
