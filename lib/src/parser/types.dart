import 'package:json_path/src/fun/type_system.dart';
import 'package:json_path/src/node.dart';

typedef NodeMapper<T> = T Function(Node node);

typedef NodeSelector = NodeMapper<Iterable<Node>>;

typedef LogicalExpression = NodeMapper<LogicalType>;
typedef ValueExpression = NodeMapper<ValueType>;
typedef NodesExpression = NodeMapper<NodesType>;
