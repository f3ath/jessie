import 'package:json_path/src/grammar/selector.dart';
import 'package:json_path/src/json_path.dart';
import 'package:json_path/src/node/node.dart';
import 'package:json_path/src/node/root_node.dart';

/// Internal implementation of [JsonPath].
class JsonPathInternal implements JsonPath {
  JsonPathInternal(this.expression, this.selector);

  /// Selector
  final Selector selector;

  /// JSONPath expression.
  final String expression;

  /// Reads the given [json] object returning an Iterable of all matches found.
  @override
  Iterable<Node> read(json) => selector(RootNode(json));

  /// Reads the given [json] object returning an Iterable of all values found.
  @override
  Iterable<dynamic> readValues(json) => read(json).map((node) => node.value);

  @override
  String toString() => expression;
}
