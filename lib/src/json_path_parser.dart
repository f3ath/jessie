import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/expression/nodes.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/grammar/json_path.dart';
import 'package:json_path/src/json_path.dart';
import 'package:json_path/src/json_path_internal.dart';
import 'package:petitparser/petitparser.dart';

/// A customizable JSONPath parser.
class JsonPathParser {
  /// Creates an instance of the parser.
  factory JsonPathParser({Iterable<Fun> userFunctions = const []}) =>
      userFunctions.isEmpty
          ? _defaultInstance
          : JsonPathParser._(userFunctions);

  JsonPathParser._(Iterable<Fun> userFunctions)
      : _parser =
            JsonPathGrammarDefinition(userFunctions).build<Expression<Nodes>>();

  /// The default instance is pre-cached to speed up parsing when only
  /// the standard built-in functions are used.
  static final _defaultInstance = JsonPathParser._(const []);

  final Parser<Expression<Nodes>> _parser;

  /// Parses the JSONPath from s string [expression].
  /// Returns an instance of [JsonPath] or throws a [FormatException].
  JsonPath parse(String expression) =>
      JsonPathInternal(expression, _parser.parse(expression).value.call);
}
