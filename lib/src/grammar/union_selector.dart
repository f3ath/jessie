import 'package:json_path/src/grammar/node_selector.dart';

NodeSelector unionSelector(Iterable<NodeSelector> selectors) =>
    (node) => selectors.expand((s) => s(node));
