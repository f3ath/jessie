import 'package:json_path/src/fun/count_fun.dart';
import 'package:json_path/src/fun/fun_call.dart';
import 'package:json_path/src/fun/fun_factory.dart';
import 'package:json_path/src/fun/length_fun.dart';
import 'package:json_path/src/fun/match_fun.dart';
import 'package:json_path/src/fun/types/logical.dart';
import 'package:json_path/src/fun/types/logical_expression.dart';
import 'package:json_path/src/fun/types/nodes.dart';
import 'package:json_path/src/fun/types/nodes_expression.dart';
import 'package:json_path/src/fun/types/value.dart';
import 'package:json_path/src/fun/types/value_expression.dart';

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
          if (f is FunFactory<Value>) {
            return f.makeFun(call.args);
          }
          if (f is FunFactory<Nodes>) {
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
          if (f is FunFactory<Logical>) {
            return f.makeFun(call.args);
          }
          if (f is FunFactory<Nodes>) {
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
    fun.map((v) => v.asLogical);

ValueExpression nodesToValue(NodesExpression fun) => fun.map((v) => v.asValue);
