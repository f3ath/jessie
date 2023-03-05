import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/expression/nodes.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

class CountFun implements Fun<Maybe<int>> {
  const CountFun();

  @override
  final name = 'count';

  @override
  Expression<Maybe<int>> toExpression(List<Expression> args) {
    if (args.length != 1) throw Exception('Invalid args');
    final arg = args.single;
    if (arg is Expression<Nodes>) return arg.map((v) => Just(v.length));
    throw FormatException('Invalid arg type');
  }
}
