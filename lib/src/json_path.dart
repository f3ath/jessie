import 'package:json_path/src/grammar/json_path.dart';
import 'package:json_path/src/node.dart';
import 'package:json_path/src/selector.dart';

/// A JSONPath expression
class JsonPath {
  /// Creates an instance from string. The [expression] is parsed once, and
  /// the instance may be used many times after that.
  ///
  /// Throws [FormatException] if the [expression] can not be parsed.
  JsonPath(this.expression) : _selector = jsonPath.parse(expression).value;

  final NodeSelector _selector;

  /// JSONPath expression.
  final String expression;

  /// Reads the given [json] object returning an Iterable of all matches found.
  Iterable<Node> read(json) => _selector(Node(json));

  /// Reads the given [json] object returning an Iterable of all values found.
  Iterable readValues(json) => read(json).map((_) => _.value);

  @override
  String toString() => expression;
}
