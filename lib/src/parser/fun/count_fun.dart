import 'package:json_path/src/parser/fun/fun_factory.dart';
import 'package:json_path/src/parser/fun/type_system.dart';
import 'package:json_path/src/parser/types/node_mapper.dart';

class CountFunFactory implements FunFactory<ValueType<int>> {
  @override
  final name = 'count';

  @override
  NodeMapper<ValueType<int>> makeFun(List args) {
    InvalidArgCount.check(name, args, 1);
    final arg = args.single;
    if (arg is! NodeMapper<Nodes>) {
      throw FormatException('Invalid arg type');
    }
    return (node) => Value(arg(node).length);
  }
}
