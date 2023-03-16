import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/expression/nodes.dart';
import 'package:json_path/src/expression/static_expression.dart';
import 'package:json_path/src/fun/built_in/string_matching_fun.dart';
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
    try {
      if (args.length == 1) {
        return any1<T>(name, args[0]);
      }
      if (args.length == 2) {
        return any2<T>(name, args[0], args[1]);
      }
    } on ArgumentError catch (e) {
      throw FormatException('Invalid argument: ${e.message}');
    } on StateError catch (e) {
      throw FormatException(e.message);
    }
    throw Exception('Type mismatch');
  }

  Expression<T> any1<T>(String name, Expression a0) {
    final f = _get1<T>(name);
    final cast0 = f is Fun1<T, Nodes> ? _nodes : _value;
    if (a0 is StaticExpression) {
      return StaticExpression(f.apply(cast0(a0.value)));
    }
    return Expression((node) => f.apply(cast0(a0.apply(node))));
  }

  Expression<T> any2<T>(String name, Expression a0, Expression a1) {
    final f = _get2<T>(name);
    final cast0 = f is Fun2<T, Nodes, dynamic> ? _nodes : _value;
    final cast1 = f is Fun2<T, dynamic, Nodes> ? _nodes : _value;

    _checkKnownTypeExpectations(f, a0, cast0, a1, cast1);

    if (a0 is StaticExpression && a1 is StaticExpression) {
      return StaticExpression(f.apply(
        cast0(a0.value),
        cast1(a1.value),
      ));
    }
    return Expression((node) => f.apply(
          cast0(a0.apply(node)),
          cast1(a1.apply(node)),
        ));
  }

  /// Checks some known type expectations for the built-in functions to detect
  /// incorrect type usage at parse time.
  void _checkKnownTypeExpectations(
    Fun2 f,
    Expression a0,
    Object Function(dynamic) cast0,
    Expression a1,
    Object Function(dynamic) cast1,
  ) {
    if (f is StringMatchingFun) {
      if (a0 is StaticExpression) {
        f.validateArg0(cast0(a0.value) as Maybe);
      }
      if (a1 is StaticExpression) {
        f.validateArg1(cast1(a1.value) as Maybe);
      }
    }
  }

  Fun1<T, dynamic> _get1<T>(String name) {
    final f = _fun1[name];
    if (f is Fun1<T, dynamic>) return f;
    throw StateError('Function "$name" of 1 argument is not found');
  }

  Fun2<T, dynamic, dynamic> _get2<T>(String name) {
    final f = _fun2[name];
    if (f is Fun2<T, dynamic, dynamic>) return f;
    throw StateError('Function "$name" of 2 arguments is not found');
  }

  static Maybe _value(v) => (v is Maybe) ? v : _nodes(v).asValue;

  static Nodes _nodes(v) {
    if (v is Nodes) return v;
    throw ArgumentError('Nodes type expected');
  }
}
