import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/expression/nodes.dart';
import 'package:json_path/src/fun/built_in/string_matching_fun.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/fun/fun_call.dart';
import 'package:json_path/src/grammar/fun_name.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:petitparser/petitparser.dart';

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

  /// Returns a function to use as an argument for another function.
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
    final cast0 = cast(value: f is Fun1<T, Maybe>, logical: f is Fun1<T, bool>);

    return a0.value
        .map(cast0)
        .map(f.apply)
        .map(Expression.fromValue)
        .orGet(() => Expression((node) => f.apply(cast0(a0.apply(node)))));
  }

  Expression<T> any2<T>(String name, Expression a0, Expression a1) {
    final f = _get2<T>(name);
    final cast0 = cast(
        value: f is Fun2<T, Maybe, dynamic>,
        logical: f is Fun2<T, bool, dynamic>);
    final cast1 = cast(
        value: f is Fun2<T, dynamic, Maybe>,
        logical: f is Fun2<T, dynamic, bool>);
    final val0 = a0.value.map(cast0);
    final val1 = a1.value.map(cast1);
    _checkKnownTypeExpectations(f, val0, val1);
    return val0
        .merge(val1, f.apply)
        .map(Expression.fromValue)
        .orGet(() => Expression((node) => f.apply(
              cast0(a0.apply(node)),
              cast1(a1.apply(node)),
            )));
  }

  /// Checks some known type expectations for the built-in functions to detect
  /// incorrect type usage at parse time.
  void _checkKnownTypeExpectations(Fun2 f, Maybe a0, Maybe a1) {
    if (f is StringMatchingFun) {
      a0.type<Maybe>().ifPresent(f.validateArg0);
      a1.type<Maybe>().ifPresent(f.validateArg1);
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

  static dynamic Function(dynamic) cast(
      {required bool value, required bool logical}) {
    if (value) return _value;
    if (logical) return _logical;
    return _nodes;
  }

  static Maybe _value(v) => (v is Maybe) ? v : _nodes(v).asValue;

  static bool _logical(v) => (v is bool) ? v : _nodes(v).asLogical;

  static Nodes _nodes(v) =>
      (v is Nodes) ? v : (throw ArgumentError('Nodes type expected'));
}
