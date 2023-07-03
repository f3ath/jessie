import 'package:json_path/src/node.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

typedef Nodes = Iterable<Node>;

extension NodesExt on Nodes {
  Maybe get asValue => length == 1 ? Just(single.value) : const Nothing();

  bool get asLogical => isNotEmpty;
}
