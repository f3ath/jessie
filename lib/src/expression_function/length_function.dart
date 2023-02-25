import 'package:json_path/src/expression_function/expression_function.dart';
import 'package:json_path/src/expression_function/fun_def.dart';
import 'package:json_path/src/expression_function/resolvable.dart';
import 'package:json_path/src/node.dart';
import 'package:json_path/src/node_mapper.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

class LengthFunction implements ExpressionFunction {
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
  apply(Node match) {
    final value = _arg.resolve(match);
    if (value is String) return value.length;
    if (value is List) return value.length;
    if (value is Map) return value.length;
    return Nothing();
  }
}

abstract class FunFactory<T> {
  NodeMapper<T> getFun();
}
//
// class LengthFun implements FunFactory<int> {
//
// }
