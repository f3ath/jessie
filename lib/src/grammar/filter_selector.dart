import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/grammar/all_children.dart';
import 'package:json_path/src/grammar/selector.dart';

Selector filterSelector(Expression<bool> filter) =>
    (node) => allChildren(node).where(filter.apply);
