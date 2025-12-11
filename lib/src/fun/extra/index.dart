import 'package:json_path/fun_sdk.dart';

/// Returns the index under which the node referenced by the argument
/// is found in the parent array.
/// If the parent is not an array, returns [Nothing].
/// If the argument does not reference a single node, returns [Nothing].
class Index implements Fun1<Maybe<int>, SingularNodeList> {
  const Index();

  @override
  final name = 'index';

  @override
  Maybe<int> call(SingularNodeList nodes) =>
      Just(nodes.node?.index).type<int>();
}
