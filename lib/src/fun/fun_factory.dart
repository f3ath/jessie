import 'package:json_path/src/expression/bool_expression.dart';
import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/expression/nodes.dart';
import 'package:json_path/src/expression/nodes_expression.dart';
import 'package:json_path/src/expression/value_expression.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/fun/fun_call.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

class FunFactory {
  FunFactory(Iterable<Fun> functions) {
    for (final f in functions) {
      if (f is Fun<Maybe>) {
        (_valueFun[f.name] ??= []).add(f);
      } else if (f is Fun<bool>) {
        (_boolFun[f.name] ??= []).add(f);
      } else if (f is Fun<Nodes>) {
        (_nodesFun[f.name] ??= []).add(f);
      } else {
        throw ArgumentError('Invalid function type for $f : ${f.runtimeType}');
      }
    }
  }

  final _valueFun = <String, List<Fun<Maybe>>>{};
  final _boolFun = <String, List<Fun<bool>>>{};
  final _nodesFun = <String, List<Fun<Nodes>>>{};

  /// Returns a function to use in comparable context.
  ValueExpression? comparable(FunCall call) =>
      _mapper(call.args, _valueFun[call.name]);

  /// Returns a function to use in logical context.
  BoolExpression? logical(FunCall call) =>
      _mapper(call.args, _boolFun[call.name]);

  /// Returns a function to use in node list context.
  NodesExpression? nodes(FunCall call) =>
      _mapper(call.args, _nodesFun[call.name]);

  Expression<R>? _mapper<R>(List<Expression> args, List<Fun<R>>? list) {
    for (final f in list ?? []) {
      try {
        return f.withArgs(args);
      } on Exception {
        continue;
      }
    }
    return null;
  }
}
