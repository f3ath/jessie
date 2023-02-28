import 'package:json_path/src/fun/fun_factory.dart';
import 'package:json_path/src/fun/types/nodes.dart';
import 'package:json_path/src/fun/types/value.dart';
import 'package:json_path/src/node_mapper.dart';
import 'package:json_path/src/static_node_mapper.dart';

class LengthFunFactory implements FunFactory<Value<int>> {
  @override
  final name = 'length';

  @override
  NodeMapper<Value<int>> makeFun(List<NodeMapper> args) {
    InvalidArgCount.check(name, args, 1);
    final arg = args.single;
    if (arg is StaticNodeMapper<Value>) {
      /// Trying an early exit.
      return StaticNodeMapper(arg.value.map(_length));
    }
    return arg.map((value) {
      if (value is Value) {
        return value.tryMap(_length);
      }
      if (value is Nodes) {
        return value.asValue.tryMap(_length);
      }
      throw FormatException('Invalid arg type');
    });
  }

  int _length(v) {
    if (v is String) return v.length;
    if (v is List) return v.length;
    if (v is Map) return v.length;
    throw FormatException('Invalid arg type: ${v.runtimeType}');
  }
}
