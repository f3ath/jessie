import 'package:json_path/src/fun/types/bool_expression.dart';
import 'package:json_path/src/fun/types/nodes.dart';
import 'package:json_path/src/fun/types/value_expression.dart';
import 'package:json_path/src/node_mapper.dart';

typedef NodesExpression = NodeMapper<Nodes>;

extension NodesExpressionExt on NodesExpression {
  /// Converts to [BoolExpression].
  BoolExpression get asLogicalExpression => map((v) => v.asBool);

  /// Converts to [ValueExpression].
  ValueExpression get asValueExpression => map((v) => v.asValue);
}
