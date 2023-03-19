import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/grammar/selector.dart';

Selector filterSelector(Expression<bool> filter) =>
    (node) => node.children.where(filter.apply);
