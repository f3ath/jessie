import 'package:json_path/functions.dart';
import 'package:json_path/src/node/node.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

extension ExpressionExt<T> on Expression<T> {
  Maybe resolveToValue(Node node) {
    final val = call(node);
    if (val is Maybe) return val;
    if (val is Nodes) return val.asValue;
    return Nothing();
  }
}
