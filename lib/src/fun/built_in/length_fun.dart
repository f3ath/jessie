import 'package:json_path/functions.dart';
import 'package:json_path/src/expression/static_expression.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

class LengthFun implements Fun<Maybe<int>> {
  const LengthFun();

  @override
  final name = 'length';

  @override
  Expression<Maybe<int>> toExpression(List<Expression> args) {
    if (args.length != 1) throw Exception('Invalid args');
    final arg = args.single;
    if (arg is StaticExpression<Maybe>) {
      return StaticExpression(arg.value.map(_length));
    }
    if (arg is Expression<Maybe>) {
      return arg.map((v) => v.tryMap(_length));
    }
    if (arg is Expression<Nodes>) {
      return arg.map((v) => v.asValue.tryMap(_length));
    }
    throw FormatException('Invalid arg type');
  }

  int _length(v) {
    if (v is String) return v.length;
    if (v is List) return v.length;
    if (v is Map) return v.length;
    throw FormatException('Invalid arg type: ${v.runtimeType}');
  }
}
