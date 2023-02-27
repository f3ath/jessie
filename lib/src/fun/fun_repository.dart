import 'package:json_path/src/fun/count_fun.dart';
import 'package:json_path/src/fun/fun_call.dart';
import 'package:json_path/src/fun/fun_factory.dart';
import 'package:json_path/src/fun/length_fun.dart';
import 'package:json_path/src/fun/match_fun.dart';
import 'package:json_path/src/fun/type_system.dart';
import 'package:json_path/src/parser/types.dart';

class FunRepository {
  final fact = <FunFactory>[
    LengthFunFactory(),
    CountFunFactory(),
    MatchFunFactory(),
    SearchFunFactory(),
  ];

  /// Returns a function to use in comparable context.
  ValueExpression makeComparableFun(FunCall call) {
    for (final f in fact) {
      if (f.name == call.name) {
        try {
          if (f is FunFactory<ValueType>) {
            return f.makeFun(call.args);
          }
          if (f is FunFactory<NodesType>) {
            return nodesToValue(f.makeFun(call.args));
          }
        } on Exception {
          continue;
        }
      }
    }
    throw Exception();
  }

  /// Returns a function to use in logical expressions.
  LogicalExpression makeLogicalFun(FunCall call) {
    for (final f in fact) {
      if (f.name == call.name) {
        try {
          if (f is FunFactory<LogicalType>) {
            return f.makeFun(call.args);
          }
          if (f is FunFactory<NodesType>) {
            return nodesToLogical(f.makeFun(call.args));
          }
        } on Exception {
          continue;
        }
      }
    }
    throw Exception();
  }
}

LogicalExpression nodesToLogical(NodesExpression fun) =>
    (node) => fun(node).asLogical;

ValueExpression nodesToValue(NodesExpression fun) =>
    (node) => fun(node).asValue;
