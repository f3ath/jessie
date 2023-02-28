import 'package:json_path/src/fun/fun_factory.dart';
import 'package:json_path/src/fun/types/nodes_expression.dart';
import 'package:json_path/src/fun/types/value.dart';
import 'package:json_path/src/node_mapper.dart';

class CountFunFactory implements FunFactory<Value<int>> {
  @override
  final name = 'count';

  @override
  NodeMapper<Value<int>> makeFun(List<NodeMapper> args) {
    InvalidArgCount.check(name, args, 1);
    final arg = args.single;
    if (arg is! NodesExpression) {
      throw FormatException('Invalid arg type');
    }
    return arg.map((v) => Value(v.length));
  }
}
