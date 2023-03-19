/// A named function which can be used in a JSONPath expression.
abstract class Fun<R> {
  /// Function name.
  String get name;
}

/// A named function with one argument.
/// The return type [R] and the argument type [T] must be one of the following:
/// - [boolean]
/// - [Maybe]
/// - [Nodes]
abstract class Fun1<R, T> extends Fun<R> {
  /// Applies the given arguments.
  /// This method MUST throw an [Exception] on invalid args.
  R apply(T arg);
}

/// A named function with two arguments.
/// The return type [R] and the argument types [T1], [T2] must be one of the following:
/// - [boolean]
/// - [Maybe]
/// - [Nodes]
abstract class Fun2<R, T1, T2> extends Fun<R> {
  /// Applies the given arguments.
  /// This method MUST throw an [Exception] on invalid args.
  R apply(T1 first, T2 second);
}
