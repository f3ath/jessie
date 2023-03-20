import 'package:json_path/src/json_path_parser.dart';
import 'package:json_path/src/node.dart';

/// A parsed JSONPath expression which can be applied to a JSON document.
abstract class JsonPath {
  /// Creates an instance from a string. The [expression] is parsed once, and
  /// the instance may be used many times after that.
  ///
  /// Throws [FormatException] if the [expression] can not be parsed.
  factory JsonPath(String expression) => JsonPathParser().parse(expression);

  /// Reads the given [json] object returning an Iterable of all matches found.
  Iterable<Node> read(json);

  /// Reads the given [json] object returning an Iterable of all values found.
  Iterable<dynamic> readValues(json);
}
