import 'package:json_path/src/node.dart';
import 'package:json_path/src/types/node_mapper.dart';

/// Selects zero or more subnodes from the JSON [node].
typedef NodeSelector = NodeMapper<Iterable<Node>>;
