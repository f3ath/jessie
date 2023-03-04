import 'package:json_path/src/node_mapper.dart';

/// A function which can be used in a JSONPath expression.
abstract class Fun<R> {
  /// Function name.
  String get name;

  /// Attaches the given arguments and creates a node mapper.
  NodeMapper<R> withArgs(List<NodeMapper> args);
}
