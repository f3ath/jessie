import 'package:json_path/src/fun/fun_factory.dart';
import 'package:json_path/src/fun/type_system.dart';
import 'package:json_path/src/node_mapper.dart';
import 'package:json_path/src/parser/types.dart';

class CountFunFactory implements FunFactory<ValueType<int>> {
  @override
  final name = 'count';

  @override
  NodeMapper<ValueType<int>> makeFun(List args) {
    InvalidArgCount.check(name, args, 1);
    final arg = args.single;
    if (arg is! NodesExpression) {
      throw FormatException('Invalid arg type');
    }
    return arg.map((v)=> Value(v.length));
  }
}
