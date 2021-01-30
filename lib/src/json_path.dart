import 'package:json_path/src/grammar/json_path.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/root_match.dart';
import 'package:json_path/src/selector.dart';
import 'package:petitparser/core.dart';

/// A JSONPath expression
class JsonPath {
  /// Creates an instance from string. The [expression] is parsed once, and
  /// the instance may be used many times after that.
  ///
  /// Throws [FormatException] if the [expression] can not be parsed.
  JsonPath(this.expression, {this.filters = const {}})
      : _selector = _parse(expression);

  static Selector _parse(String expression) {
    try {
      return jsonPath.parse(expression).value;
    } on ParserException catch (e) {
      throw FormatException('$e. Expression: ${e.source}');
    }
  }

  /// JSONPath expression.
  final String expression;
  final Selector _selector;

  /// Named callback filters
  final Map<String, CallbackFilter> filters;

  /// Reads the given [document] object returning an Iterable of all matches found.
  Iterable<JsonPathMatch> read(document,
          {Map<String, CallbackFilter> filters = const {}}) =>
      _selector.apply(RootMatch(document, {...this.filters, ...filters}));

  /// Reads the given [json] object returning an Iterable of all values found.
  Iterable readValues(json) => read(json).map((_) => _.value);

  @override
  String toString() => expression;
}
