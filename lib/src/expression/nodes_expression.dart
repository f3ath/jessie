import 'package:json_path/src/expression/bool_expression.dart';
import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/expression/nodes.dart';
import 'package:json_path/src/expression/value_expression.dart';

typedef NodesExpression = Expression<Nodes>;

extension NodesExpressionExt on NodesExpression {
  /// Converts to [BoolExpression].
  BoolExpression get asLogicalExpression => map((v) => v.asBool);

  /// Converts to [ValueExpression].
  ValueExpression get asValueExpression => map((v) => v.asValue);
}
