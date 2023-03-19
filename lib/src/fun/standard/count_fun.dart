import 'package:json_path/src/expression/nodes.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

/// The standard `count()` function which returns the number of nodes in a node list.
class CountFun implements Fun1<Maybe, Nodes> {
  const CountFun();

  @override
  final name = 'count';

  @override
  Maybe apply(Nodes nodes) => Just(nodes.length);
}
