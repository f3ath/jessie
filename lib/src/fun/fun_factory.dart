import 'package:json_path/src/node_mapper.dart';

abstract class FunFactory<R, V> {
  FunFactory(this.name, this.argCount);

  /// Function name.
  final String name;

  /// Arguments count.
  final int argCount;

  /// Combines the arguments passed to the function
  /// into the single value object.
  V convertArgs(List<NodeMapper> args);

  NodeMapper<R> apply(V arg);

  NodeMapper<R> build(List<NodeMapper> args) {
    if (argCount != args.length) {
      throw InvalidArgCount(name, argCount, args.length);
    }
    return apply(convertArgs(args));
  }
}

class InvalidArgCount extends FormatException {
  InvalidArgCount(String name, int expected, int actual)
      : super('Function $name expects $expected arg(s), but got $actual');
}
