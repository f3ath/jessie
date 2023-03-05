import 'package:json_path/src/expression/nodes_expression.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/grammar/json_path.dart';
import 'package:json_path/src/node/node.dart';
import 'package:json_path/src/node/root_node.dart';
import 'package:petitparser/parser.dart';

/// A parsed JSONPath expression which can be applied to a JSON document.
class JsonPath {
  /// Creates an instance from string. The [expression] is parsed once, and
  /// the instance may be used many times after that.
  ///
  /// Throws [FormatException] if the [expression] can not be parsed.
  factory JsonPath(String expression) =>
      JsonPathParser._defaultInstance.parse(expression);

  JsonPath._(this.expression, this._nodes);

  final NodesExpression _nodes;

  /// JSONPath expression.
  final String expression;

  /// Reads the given [json] object returning an Iterable of all matches found.
  Iterable<Node> read(json) => _nodes.call(RootNode(json));

  /// Reads the given [json] object returning an Iterable of all values found.
  Iterable<dynamic> readValues(json) => read(json).map((node) => node.value);

  @override
  String toString() => expression;
}

/// Parses the JSONPath expression from string. This class can be customized
/// with user-defined functions.
class JsonPathParser {
  factory JsonPathParser({Iterable<Fun> userFunctions = const []}) =>
      userFunctions.isEmpty
          ? _defaultInstance
          : JsonPathParser._(userFunctions);

  JsonPathParser._(Iterable<Fun> userFunctions)
      : _parser =
            JsonPathGrammarDefinition(userFunctions).build<NodesExpression>();

  /// The default instance is pre-cached to speed up parsing when only
  /// the standard built-in functions are used.
  static final _defaultInstance = JsonPathParser._(const []);

  final Parser<NodesExpression> _parser;

  /// Parses the JSONPath from s string [expression].
  /// Returns an instance of [JsonPath] or throws a [FormatException].
  JsonPath parse(String expression) =>
      JsonPath._(expression, _parser.parse(expression).value);
}
