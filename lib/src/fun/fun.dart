import 'package:json_path/src/expression/expression.dart';

/// A function which can be used in a JSONPath expression.
abstract class Fun<R> {
  /// Function name.
  String get name;

  /// Attaches the given arguments and creates a function expression.
  /// This method MUST throw an [Exception] if the provided [args]
  /// have the incorrect length or types.
  Expression<R> toExpression(List<Expression> args);
}
