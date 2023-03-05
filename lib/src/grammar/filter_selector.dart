import 'package:json_path/src/expression/bool_expression.dart';
import 'package:json_path/src/grammar/node_selector.dart';
import 'package:json_path/src/grammar/select_all.dart';

NodeSelector filterSelector(BoolExpression filter) =>
    (node) => selectAll(node).where(filter.call);
