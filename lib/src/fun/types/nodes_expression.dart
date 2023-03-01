import 'package:json_path/src/fun/types/logical_expression.dart';
import 'package:json_path/src/fun/types/nodes.dart';
import 'package:json_path/src/fun/types/value_expression.dart';
import 'package:json_path/src/node_mapper.dart';

typedef NodesExpression = NodeMapper<Nodes>;

extension NodesExpressionExt on NodesExpression {
  /// Converts to [LogicalExpression].
  LogicalExpression get asLogicalExpression => map((v) => v.asLogical);

  /// Converts to [ValueExpression].
  ValueExpression get asValueExpression => map((v) => v.asValue);
}
