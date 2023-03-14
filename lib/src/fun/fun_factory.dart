import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/expression/nodes.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/fun/fun_call.dart';
import 'package:json_path/src/grammar/fun_name.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:petitparser/petitparser.dart';

typedef F1<R, T1> = Expression<R> Function(
  Expression<T1> a,
);

class FunFactory {
  FunFactory(Iterable<Fun> functions) {
    for (final f in functions) {
      _validateName(f.name);
      if (f is Fun1) {
        _fun1[f.name] = f;
      } else if (f is Fun2) {
        _fun2[f.name] = f;
      } else {
        throw ArgumentError('Type mismatch');
      }
    }
  }

  void _validateName(String name) {
    if (!funName.allMatches(name).contains(name)) {
      throw ArgumentError('Invalid function name $name');
    }
  }

  final _fun1 = <String, Fun1>{};
  final _fun2 = <String, Fun2>{};

  /// Returns a function to use in comparable context.
  Expression<Maybe> comparable(FunCall call) => any<Maybe>(call);

  /// Returns a function to use in logical context.
  Expression<bool> logical(FunCall call) => any<bool>(call);

  /// Returns a function to use in any context.
  Expression<T> any<T>(FunCall call) {
    final name = call.name;
    final args = call.args;
    if (args.length == 1) {
      return any1<T>(name, args[0]);
    } else if (args.length == 2) {
      return any2<T>(name, args[0], args[1]);
    }
    throw Exception('Type mismatch');
  }

  Expression<T> any1<T>(String name, Expression arg0) {
    final f = _fun1[name] ?? (throw Exception('No fun'));
    if (f is Fun1<T, dynamic>) {
      return f.apply(
        _cast(
          arg0,
          value: f is Fun1<T, Maybe>,
          nodes: f is Fun1<T, Nodes>,
        ),
      );
    }
    throw Exception('Type mismatch');
  }

  Expression<T> any2<T>(String name, Expression arg0, Expression arg1) {
    final f = _fun2[name] ?? (throw Exception('No fun'));
    if (f is Fun2<T, dynamic, dynamic>) {
      return f.apply(
        _cast(arg0,
            value: f is Fun2<dynamic, Maybe, dynamic>,
            nodes: f is Fun2<dynamic, Nodes, dynamic>),
        _cast(arg1,
            value: f is Fun2<dynamic, dynamic, Maybe>,
            nodes: f is Fun2<dynamic, dynamic, Nodes>),
      );
    }
    throw Exception('Type mismatch');
  }

  Expression _cast(
    Expression e, {
    required bool value,
    required bool nodes,
  }) {
    if (value) return _value(e);
    if (nodes) return _nodes(e);
    throw Exception('Type mismatch');
  }

  Expression<Maybe> _value(Expression e) {
    if (e is Expression<Maybe>) return e;
    if (e is Expression<Nodes>) return e.map((v) => v.asValue);
    throw Exception('Type mismatch');
  }

  Expression<Nodes> _nodes(Expression e) {
    if (e is Expression<Nodes>) return e;
    throw Exception('Type mismatch');
  }
}
