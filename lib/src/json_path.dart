import 'package:json_path/src/fun/types/nodes_expression.dart';
import 'package:json_path/src/json_path_parser.dart';
import 'package:json_path/src/node.dart';
import 'package:json_path/src/root_node.dart';

/// A JSONPath expression
class JsonPath {
  /// Creates an instance from string. The [expression] is parsed once, and
  /// the instance may be used many times after that.
  ///
  /// Throws [FormatException] if the [expression] can not be parsed.
  JsonPath(this.expression)
      : _selector = _defaultParser.parse(expression).value;

  static final _defaultParser = jsonPathParser();

  final NodesExpression _selector;

  /// JSONPath expression.
  final String expression;

  /// Reads the given [json] object returning an Iterable of all matches found.
  Iterable<Node> read(json) => _selector.applyTo(RootNode(json));

  /// Reads the given [json] object returning an Iterable of all values found.
  Iterable<dynamic> readValues(json) => read(json).map((node) => node.value);

  @override
  String toString() => expression;
}
