import 'package:json_path/src/fun/fun_factory.dart';
import 'package:json_path/src/fun/resolvable.dart';
import 'package:json_path/src/fun/type_system.dart';
import 'package:json_path/src/node_mapper.dart';
import 'package:json_path/src/parser/types.dart';

class LengthFunFactory implements FunFactory<ValueType<int>> {
  @override
  final name = 'length';

  @override
  NodeMapper<ValueType<int>> makeFun(List args) {
    InvalidArgCount.check(name, args, 1);
    final arg = args.single;
    if (!(arg is NodesExpression ||
        arg is String ||
        arg is List ||
        arg is Map)) {
      throw FormatException('Invalid arg type');
    }
    return NodeMapper((node) {
      final value = Resolvable(arg).resolve(node);
      if (value is String) return Value(value.length);
      if (value is List) return Value(value.length);
      if (value is Map) return Value(value.length);
      return const Nothing<int>();
    });
  }
}
