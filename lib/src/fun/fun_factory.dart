import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/expression/nodes.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/fun/fun_call.dart';
import 'package:json_path/src/fun/fun_validator.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

class FunFactory {
  FunFactory(Iterable<Fun> functions) {
    final errors = functions.expand(_validator.errors);
    if (errors.isNotEmpty) {
      throw ArgumentError('Function validation errors: ${errors.join(', ')}');
    }
    for (final f in functions) {
      if (f is Fun1) _fun1[f.name] = f;
      if (f is Fun2) _fun2[f.name] = f;
    }
  }

  static final _validator = FunValidator();

  final _fun1 = <String, Fun1>{};
  final _fun2 = <String, Fun2>{};

  /// Returns a value-type function to use in comparable context.
  Expression<Maybe> value(FunCall call) => _any<Maybe>(call);

  /// Returns a logical-type function to use in logical context.
  Expression<bool> logical(FunCall call) => _any<bool>(call);

  /// Returns a nodes-type function.
  Expression<NodeList> nodes(FunCall call) => _any<NodeList>(call);

  /// Returns a function to use as an argument for another function.
  Expression<T> _any<T extends Object>(FunCall call) => switch (call.args) {
        [var a] => _any1<T>(call.name, a),
        [var a, var b] => _any2<T>(call.name, a, b),
        _ => throw Exception('Invalid number of args for ${call.name}()'),
      };

  Expression<T> _any1<T extends Object>(String name, Expression a0) {
    final f = _getFun1<T>(name);
    final cast0 = cast(
      a0,
      value: f is Fun1<T, Maybe>,
      logical: f is Fun1<T, bool>,
      node: f is Fun1<T, SingularNodeList>,
      nodes: f is Fun1<T, NodeList>,
    );
    return cast0.map(f.call);
  }

  Expression<T> _any2<T extends Object>(
      String name, Expression a0, Expression a1) {
    final f = _getFun2<T>(name);
    final cast0 = cast(
      a0,
      value: f is Fun2<T, Maybe, Object>,
      logical: f is Fun2<T, bool, Object>,
      node: f is Fun2<T, SingularNodeList, Object>,
      nodes: f is Fun2<T, NodeList, Object>,
    );
    final cast1 = cast(
      a1,
      value: f is Fun2<T, Object, Maybe>,
      logical: f is Fun2<T, Object, bool>,
      node: f is Fun2<T, Object, SingularNodeList>,
      nodes: f is Fun2<T, Object, NodeList>,
    );
    return cast0.merge(cast1, f.call);
  }

  Fun1<T, Object> _getFun1<T extends Object>(String name) {
    final f = _fun1[name];
    if (f is Fun1<T, Object>) return f;
    throw FormatException('Function "$name" of 1 argument is not found');
  }

  Fun2<T, Object, Object> _getFun2<T extends Object>(String name) {
    final f = _fun2[name];
    if (f is Fun2<T, Object, Object>) return f;
    throw FormatException('Function "$name" of 2 arguments is not found');
  }

  static Expression cast(
    Expression arg, {
    required bool value,
    required bool logical,
    required bool node,
    required bool nodes,
  }) {
    if (value) {
      if (arg is Expression<Maybe>) return arg;
      if (arg is Expression<SingularNodeList>) return arg.map((v) => v.asValue);
    } else if (logical) {
      if (arg is Expression<bool>) return arg;
      if (arg is Expression<NodeList>) return arg.map((v) => v.asLogical);
    } else if (node) {
      if (arg is Expression<SingularNodeList>) return arg;
    } else if (nodes) {
      if (arg is Expression<NodeList>) return arg;
    }
    throw Exception('Arg type mismatch');
  }
}
