import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/expression/nodes.dart';
import 'package:json_path/src/expression/static_expression.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/fun/fun_call.dart';
import 'package:json_path/src/fun/fun_validator.dart';
import 'package:json_path/src/fun/standard/string_matcher.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

class FunFactory {
  FunFactory(Iterable<Fun> functions) {
    final errors = functions.expand(_validator.errors);
    if (errors.isNotEmpty) {
      throw ArgumentError('Function validation errors: ${errors.join(', ')}');
    }
    for (final f in functions) {
      if (f is Fun1) {
        _fun1[f.name] = f;
      }
      if (f is Fun2) {
        _fun2[f.name] = f;
      }
    }
  }

  static final _validator = FunValidator();

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
    return a0.map(cast0).map(f.call);
  }

  Expression<T> any2<T>(String name, Expression a0, Expression a1) {
    final f = _get2<T>(name);
    final cast0 = cast(
        value: f is Fun2<T, Maybe, dynamic>,
        logical: f is Fun2<T, bool, dynamic>);
    final cast1 = cast(
        value: f is Fun2<T, dynamic, Maybe>,
        logical: f is Fun2<T, dynamic, bool>);
    final converted0 = a0.map(cast0);
    final converted1 = a1.map(cast1);
    if (f is StringMatcher) {
      // TODO: make parse-time detection cleaner
      if (converted0 is StaticExpression) {
        (f as StringMatcher).validateArg0(converted0.value);
      }
      if (converted1 is StaticExpression) {
        (f as StringMatcher).validateArg1(converted1.value);
      }
    }
    return converted0.merge(converted1, f.call);
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
