import 'package:json_path/src/expression_function/expression_function.dart';
import 'package:json_path/src/expression_function/types.dart';
import 'package:json_path/src/node.dart';
import 'package:json_path/src/types/node_mapper.dart';

class CountFunction implements ExpressionFunction<ValueType> {
  CountFunction(this._mapper);

  static CountFunction fromArgs(List args) {
    if (args.length != 1) {
      // TODO: exception type should be different. ArgumentError maybe?
      throw FormatException('Wrong number of arguments');
    }
    final arg = args.single;
    if (arg is! NodeMapper<Iterable<Node>>) {
      throw FormatException('Invalid argument type');
    }
    return CountFunction(arg);
  }

  final NodeMapper<Iterable<Node>> _mapper;

  @override
  Value apply(Node node) => Value(_mapper(node).length);
}
