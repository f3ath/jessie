import 'package:json_path/src/expression_function/fun_factory.dart';
import 'package:json_path/src/expression_function/resolvable.dart';
import 'package:json_path/src/expression_function/types.dart';
import 'package:json_path/src/types/node_mapper.dart';

class LengthFunFactory implements FunFactory<ValueType<int>> {
  @override
  final name = 'length';

  @override
  NodeMapper<ValueType<int>> makeFun(List args) {
    InvalidArgCount.check(name, args, 1);
    final arg = args.single;
    if (!(arg is NodeMapper<Nodes> ||
        arg is String ||
        arg is List ||
        arg is Map)) {
      throw FormatException('Invalid arg type');
    }
    return (node) {
      final value = Resolvable(arg).resolve(node);
      if (value is String) return Value(value.length);
      if (value is List) return Value(value.length);
      if (value is Map) return Value(value.length);
      return const Nothing<int>();
    };
  }
}
