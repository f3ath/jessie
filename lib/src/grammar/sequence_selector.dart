import 'package:json_path/src/expression/nodes.dart';
import 'package:json_path/src/selector.dart';

Selector sequenceSelector(Iterable<Selector> selectors) =>
    (node) => selectors.fold<_Filter>(
        (v) => v,
        (filter, selector) =>
            (nodes) => filter(nodes).expand(selector))([node]);

SingularSelector singularSequenceSelector(
        Iterable<SingularSelector> selectors) =>
    (node) => selectors.fold<_SingularFilter>(
        SingularNodeList.new,
        (filter, selector) => (nodes) =>
            SingularNodeList(filter(nodes).expand(selector)))([node]);

typedef _Filter = NodeList Function(NodeList nodes);

typedef _SingularFilter = SingularNodeList Function(NodeList nodes);
