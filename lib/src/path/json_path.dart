import 'package:json_path/src/path/grammar.dart' as grammar;
import 'package:json_path/src/path/json_path_match.dart';
import 'package:json_path/src/path/match_factory.dart';
import 'package:json_path/src/path/selector/selector.dart';

/// A JSONPath expression
class JsonPath {
  /// Creates an instance from string. The [expression] is parsed once, and
  /// the instance may be used many times after that.
  ///
  /// Throws [FormatException] if the [expression] can not be parsed.
  JsonPath(this.expression, {this.filters = const {}})
      : _selector = grammar.jsonPath.parse(expression).value;

  /// JSONPath expression.
  final String expression;
  final Selector _selector;

  /// Named callback filters
  final Map<String, CallbackFilter> filters;

  /// Reads the given [document] object returning an Iterable of all matches found.
  Iterable<JsonPathMatch> read(document,
          {Map<String, CallbackFilter> filters = const {}}) =>
      _selector
          .read(rootMatch(document, expression, {...this.filters, ...filters}));

  /// Reads the given [json] object returning an Iterable of all values found.
  Iterable readValues(json) => read(json).map((_) => _.value);

  @override
  String toString() => expression;
}
