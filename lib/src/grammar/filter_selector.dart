import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/grammar/node_selector.dart';
import 'package:json_path/src/grammar/select_all.dart';

NodeSelector filterSelector(Expression<bool> filter) =>
    (node) => selectAll(node).where(filter.apply);
