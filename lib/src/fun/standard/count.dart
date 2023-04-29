import 'package:json_path/src/expression/nodes.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

/// The standard `count()` function which returns the number of nodes in a node list.
/// See https://ietf-wg-jsonpath.github.io/draft-ietf-jsonpath-base/draft-ietf-jsonpath-base.html#name-count-function-extension
class Count implements Fun1<Maybe, Nodes> {
  const Count();

  @override
  final name = 'count';

  @override
  Maybe call(Nodes nodes) => Just(nodes.length);
}
