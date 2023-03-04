import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/expression/nodes.dart';
import 'package:json_path/src/expression/static_expression.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

class LengthFun implements Fun<Maybe<int>> {
  const LengthFun();

  @override
  final name = 'length';

  @override
  Expression<Maybe<int>> withArgs(List<Expression> args) {
    if (args.length != 1) throw Exception('Invalid args');
    final arg = args.single;
    if (arg is StaticExpression<Maybe>) {
      return StaticExpression(arg.value.map(_length));
    }
    return arg.map((value) {
      if (value is Maybe) return value.flatMap(_maybeLength);
      if (value is Nodes) return value.asValue.flatMap(_maybeLength);
      throw FormatException('Invalid arg type');
    });
  }

  int _length(v) {
    if (v is String) return v.length;
    if (v is List) return v.length;
    if (v is Map) return v.length;
    throw FormatException('Invalid arg type: ${v.runtimeType}');
  }

  Maybe<int> _maybeLength(v) {
    try {
      return Just(_length(v));
    } on Exception {
      return Nothing();
    }
  }
}
