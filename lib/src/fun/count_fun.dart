import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/fun/types/nodes_expression.dart';
import 'package:json_path/src/node_mapper.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

class CountFun implements Fun<Maybe<int>> {
  const CountFun();

  @override
  final name = 'count';

  @override
  NodeMapper<Maybe<int>> withArgs(List<NodeMapper> args) {
    if (args.length != 1) throw Exception('Invalid args');
    final arg = args[0];
    if (arg is NodesExpression) return arg.map((v) => Just(v.length));
    throw FormatException('Invalid arg type');
  }
}
