import 'package:json_path/src/fun/fun_factory.dart';
import 'package:json_path/src/fun/types/nodes.dart';
import 'package:json_path/src/node_mapper.dart';
import 'package:json_path/src/static_node_mapper.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

class LengthFunFactory extends FunFactory<Maybe<int>, NodeMapper> {
  LengthFunFactory() : super('length', 1);

  @override
  NodeMapper convertArgs(List<NodeMapper> args) => args.single;

  @override
  NodeMapper<Maybe<int>> apply(NodeMapper arg) {
    if (arg is StaticNodeMapper<Maybe>) {
      return StaticNodeMapper(arg.value.map(length));
    }
    return arg.map((value) {
      if (value is Maybe) return value.flatMap(maybeLength);
      if (value is Nodes) return value.asValue.flatMap(maybeLength);
      throw FormatException('Invalid arg type');
    });
  }

  Maybe<int> maybeLength(v) {
    try {
      return Just(length(v));
    } on Exception {
      return Nothing();
    }
  }

  int length(v) {
    if (v is String) return v.length;
    if (v is List) return v.length;
    if (v is Map) return v.length;
    throw FormatException('Invalid arg type: ${v.runtimeType}');
  }
}
