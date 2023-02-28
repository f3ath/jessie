import 'package:json_path/src/fun/type_system.dart';
import 'package:json_path/src/node.dart';
import 'package:json_path/src/node_mapper.dart';

typedef NodeSelector = Iterable<Node> Function(Node node);

typedef LogicalExpression = NodeMapper<LogicalType>;
typedef ValueExpression = NodeMapper<ValueType>;
typedef NodesExpression = NodeMapper<NodesType>;
