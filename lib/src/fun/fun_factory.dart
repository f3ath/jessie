import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/expression/nodes.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/fun/fun_call.dart';
import 'package:json_path/src/grammar/fun_name.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:petitparser/petitparser.dart';

class FunFactory {
  FunFactory(Iterable<Fun> functions) {
    for (final f in functions) {
      _validateName(f.name);
      (_anyFun[f.name] ??= []).add(f);

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

  static void _validateName(String name) {
    if (!funName.allMatches(name).contains(name)) {
      throw ArgumentError('Invalid function name $name');
    }
  }

  final _valueFun = <String, List<Fun<Maybe>>>{};
  final _boolFun = <String, List<Fun<bool>>>{};
  final _nodesFun = <String, List<Fun<Nodes>>>{};
  final _anyFun = <String, List<Fun>>{};

  /// Returns a function to use in comparable context.
  Expression<Maybe>? comparable(FunCall call) =>
      _mapper(call.args, _valueFun[call.name]);

  /// Returns a function to use in logical context.
  Expression<bool>? logical(FunCall call) =>
      _mapper(call.args, _boolFun[call.name]);

  /// Returns a function to use in node list context.
  Expression<Nodes>? nodes(FunCall call) =>
      _mapper(call.args, _nodesFun[call.name]);

  /// Returns a function to us in any context.
  Expression? any(FunCall call) {
    print('any $call');
    // print(StackTrace.current);
    return _mapper(call.args, _anyFun[call.name]);
  }

  Expression<R>? _mapper<R>(List<Expression> args, List<Fun<R>>? list) {
    for (final fun in list ?? []) {
      print(fun);
      // print(StackTrace.current);
      try {
        return fun.toExpression(args);
      } on Exception {
        continue;
      }
    }
    return null;
  }
}
