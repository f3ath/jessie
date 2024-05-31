import 'package:json_path/fun_sdk.dart';

/// Returns the key under which the node referenced by the argument
/// is found in the parent object.
/// If the parent is not an object, returns [Nothing].
/// If the argument does not reference a single node, returns [Nothing].
class Key implements Fun1<Maybe, SingularNodeList> {
  const Key();

  @override
  final name = 'key';

  @override
  Maybe call(SingularNodeList nodes) => Just(nodes.node?.key).type<String>();
}
