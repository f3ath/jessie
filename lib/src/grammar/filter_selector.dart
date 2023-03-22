import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/selector/selector.dart';

SelectorFun filterSelector(Expression<bool> filter) =>
    (node) => node.children.where(filter.call);
