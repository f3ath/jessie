import 'package:json_path/src/grammar/json_path.dart';
import 'package:json_path/src/node.dart';
import 'package:json_path/src/root_node.dart';
import 'package:json_path/src/selector.dart';

/// A JSONPath expression
class JsonPath {
  /// Creates an instance from string. The [expression] is parsed once, and
  /// the instance may be used many times after that.
  ///
  /// Throws [FormatException] if the [expression] can not be parsed.
  JsonPath(this.expression) : _selector = jsonPath.parse(expression).value;

  final Selector _selector;

  /// JSONPath expression.
  final String expression;

  /// Reads the given [document] object returning an Iterable of all matches found.
  Iterable<Node> read(document) => _selector.apply(RootNode(document));

  /// Reads the given [json] object returning an Iterable of all values found.
  Iterable readValues(json) => read(json).map((_) => _.value);

  @override
  String toString() => expression;
}
