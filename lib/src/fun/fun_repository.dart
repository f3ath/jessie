import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/fun/fun_call.dart';
import 'package:json_path/src/fun/types/bool_expression.dart';
import 'package:json_path/src/fun/types/nodes.dart';
import 'package:json_path/src/fun/types/nodes_expression.dart';
import 'package:json_path/src/fun/types/value_expression.dart';
import 'package:json_path/src/node_mapper.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

class FunRepository {
  FunRepository(Iterable<Fun> functions) {
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

  NodeMapper<R>? _mapper<R>(List<NodeMapper> args, List<Fun<R>>? list) {
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
