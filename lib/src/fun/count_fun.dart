import 'package:json_path/src/fun/fun_factory.dart';
import 'package:json_path/src/fun/types/nodes_expression.dart';
import 'package:json_path/src/node_mapper.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

class CountFunFactory extends FunFactory<Maybe<int>, NodesExpression> {
  CountFunFactory() : super('count', 1);

  @override
  NodesExpression convertArgs(List<NodeMapper> args) {
    final arg = args.single;
    if (arg is NodesExpression) return arg;
    throw FormatException('Invalid arg type');
  }

  @override
  NodeMapper<Maybe<int>> apply(NodesExpression arg) =>
      arg.map((v) => Just(v.length));
}
