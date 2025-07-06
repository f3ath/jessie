import 'package:json_path/src/node.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

typedef NodeList = Iterable<Node>;

class SingularNodeList with NodeList {
  SingularNodeList(this._nodes);

  SingularNodeList.from(Node? node)
    : this(node != null ? [node] : const Iterable.empty());

  final NodeList _nodes;

  Node? get node => length == 1 ? first : null;

  @override
  Iterator<Node<Object?>> get iterator => _nodes.iterator;
}

extension NodeListExt on NodeList {
  Maybe get asValue => length == 1 ? Just(single.value) : const Nothing();

  bool get asLogical => isNotEmpty;
}
