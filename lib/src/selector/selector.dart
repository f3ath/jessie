import 'package:json_path/fun_sdk.dart';

typedef SelectorFun = Nodes Function(Node node);

abstract class Selector {
  const Selector();

  /// Given the current [node], selects zero or more from the entire document.
  Nodes select(Node node);
}

/// Selects the root node of the document.
class Root extends Selector {
  const Root();

  @override
  Nodes select(Node<Object?> node) sync* {
    yield node.root;
  }
}

/// Selects the current node.
class Current extends Selector {
  const Current();

  @override
  Nodes select(Node<Object?> node) sync* {
    yield node;
  }
}
