import 'package:json_path/src/expression_function/expression_function.dart';
import 'package:json_path/src/expression_function/fun_def.dart';
import 'package:json_path/src/expression_function/resolvable.dart';
import 'package:json_path/src/expression_function/types.dart';
import 'package:json_path/src/node.dart';
import 'package:json_path/src/types/node_mapper.dart';

class LengthFunction implements ExpressionFunction<ValueType> {
  LengthFunction(this._arg);

  static final fun = FunDef([
    (arg) => arg is NodeMapper || arg is String || arg is List || arg is Map
        ? []
        : ['Invalid type']
  ]);

  static LengthFunction fromArgs(List args) {
    final errors = fun.validate(args);
    if (errors.isNotEmpty) {
      throw FormatException('Function length: ${errors.join('; ')}');
    }
    return LengthFunction(Resolvable(args[0]));
  }

  final Resolvable _arg;

  @override
  ValueType apply(Node node) {
    final value = _arg.resolve(node);
    if (value is String) return Value(value.length);
    if (value is List) return Value(value.length);
    if (value is Map) return Value(value.length);
    return const Nothing();
  }
}

abstract class FunFactory<T> {
  NodeMapper<T> getFun();
}
