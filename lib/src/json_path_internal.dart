import 'package:json_path/src/json_path.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/node.dart';
import 'package:json_path/src/node_match.dart';
import 'package:json_path/src/selector.dart';

/// Internal implementation of [JsonPath].
class JsonPathInternal implements JsonPath {
  JsonPathInternal(this.expression, this.selector);

  /// Selector
  final Selector selector;

  /// JSONPath expression.
  final String expression;

  /// Reads the given [json] object returning an Iterable of all matches found.
  @override
  Iterable<JsonPathMatch> read(json) => selector(Node(json)).map(NodeMatch.new);

  /// Reads the given [json] object returning an Iterable of all values found.
  @override
  Iterable<Object?> readValues(json) => read(json).map((node) => node.value);

  @override
  String toString() => expression;
}
