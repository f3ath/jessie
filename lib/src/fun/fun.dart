import 'package:json_path/src/expression/expression.dart';

/// A named function which can be used in a JSONPath expression.
abstract class Fun<R> {
  /// Function name.
  String get name;
}

/// A named function with one argument.
/// The return type [R] must be one of the following:
/// - [boolean]
/// - [Maybe]
/// - [Nodes]
///
/// The argument type [T] must be on of:
/// - [Maybe]
/// - [Nodes]
abstract class Fun1<R, T> extends Fun<R> {
  /// Applies the given arguments.
  /// This method MUST throw an [Exception] on invalid args.
  Expression<R> apply(Expression<T> arg);
}

/// A named function with two arguments.
/// The return type [R] must be one of the following:
/// - [boolean]
/// - [Maybe]
/// - [Nodes]
///
/// The argument types [T1] and [T2] must be on of:
/// - [Maybe]
/// - [Nodes]
abstract class Fun2<R, T1, T2> extends Fun<R> {
  /// Applies the given arguments.
  /// This method MUST throw an [Exception] on invalid args.
  Expression<R> apply(Expression<T1> first, Expression<T2> second);
}
