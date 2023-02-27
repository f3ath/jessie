import 'package:json_path/src/parser/types.dart';

abstract class FunFactory<T> {
  String get name;

  /// Creates a function with the [args].
  NodeMapper<T> makeFun(List args);
}

class InvalidArgCount extends FormatException {
  InvalidArgCount(String name, int expected, int actual)
      : super('Function $name expects $expected arg(s), but got $actual');

  /// Checks the arg count and throws is necessary.
  static void check(String name, List args, int expected) {
    final actual = args.length;
    if (expected != actual) throw InvalidArgCount(name, expected, actual);
  }
}
