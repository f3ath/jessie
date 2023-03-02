import 'package:json_path/src/fun/count_fun.dart';
import 'package:json_path/src/fun/fun_call.dart';
import 'package:json_path/src/fun/fun_factory.dart';
import 'package:json_path/src/fun/length_fun.dart';
import 'package:json_path/src/fun/match_fun.dart';
import 'package:json_path/src/fun/types/bool_expression.dart';
import 'package:json_path/src/fun/types/nodes.dart';
import 'package:json_path/src/fun/types/nodes_expression.dart';
import 'package:json_path/src/fun/types/value_expression.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

class FunRepository {
  final fact = <FunFactory>[
    LengthFunFactory(),
    CountFunFactory(),
    MatchFunFactory(),
    SearchFunFactory(),
  ];

  /// Returns a function to use in comparable context.
  ValueExpression makeComparableFun(FunCall call) => _findFactory(call, (fun) {
        if (fun is FunFactory<Maybe, dynamic>) {
          return fun.build(call.args);
        }
        if (fun is FunFactory<Nodes, dynamic>) {
          return fun.build(call.args).asValueExpression;
        }
        return null;
      });

  /// Returns a function to use in logical expressions.
  BoolExpression makeLogicalFun(FunCall call) => _findFactory(call, (fun) {
        if (fun is FunFactory<bool, dynamic>) {
          return fun.build(call.args);
        }
        if (fun is FunFactory<Nodes, dynamic>) {
          return fun.build(call.args).asLogicalExpression;
        }
        return null;
      });

  T _findFactory<T>(FunCall call, T? Function(FunFactory fun) tryBuild) {
    for (final factory in fact) {
      if (factory.name != call.name || factory.argCount != call.args.length) {
        continue;
      }
      try {
        final fun = tryBuild(factory);
        if (fun == null) continue;
        return fun;
      } on Exception {
        continue;
      }
    }
    throw Exception('No implementation for $call found');
  }
}
