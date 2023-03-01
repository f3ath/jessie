import 'package:json_path/src/fun/fun_factory.dart';
import 'package:json_path/src/fun/types/nodes.dart';
import 'package:json_path/src/fun/types/value.dart';
import 'package:json_path/src/node_mapper.dart';
import 'package:json_path/src/static_node_mapper.dart';

class LengthFunFactory extends FunFactory<Value<int>, NodeMapper> {
  LengthFunFactory() : super('length', 1);

  @override
  NodeMapper convertArgs(List<NodeMapper> args) => args.single;

  @override
  NodeMapper<Value<int>> apply(NodeMapper arg) {
    if (arg is StaticNodeMapper<Value>) {
      return StaticNodeMapper(arg.value.map(length));
    }
    return arg.map((value) {
      if (value is Value) return value.tryMap(length);
      if (value is Nodes) return value.asValue.tryMap(length);
      throw FormatException('Invalid arg type');
    });
  }

  int length(v) {
    if (v is String) return v.length;
    if (v is List) return v.length;
    if (v is Map) return v.length;
    throw FormatException('Invalid arg type: ${v.runtimeType}');
  }
}
