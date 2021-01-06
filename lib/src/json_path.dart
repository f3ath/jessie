import 'package:json_path/json_pointer.dart';
import 'package:json_path/src/build_parser.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/selector.dart';

/// A JSONPath expression
class JsonPath {
  /// Creates an instance from string. The [expression] is parsed once, and
  /// the instance may be used many times after that.
  ///
  /// Throws [FormatException] if the [expression] can not be parsed.
  JsonPath(this.expression)
      : _selectors = buildParser().parse(expression).value;

  /// JSONPath expression.
  final String expression;
  final Iterable<Selector> _selectors;

  /// Reads the given [json] object returning an Iterable of all matches found.
  Iterable<JsonPathMatch> read(json) {
    final root = [JsonPathMatch(json, r'$', JsonPointer())];
    final transform = _selectors.fold<Transformer>(
            (_) => _, (tr, selector) => (_) => selector.read(tr(_)));
    return transform(root);
  }

  /// Reads the given [json] object returning an Iterable of all values found.
  Iterable readValues(json) => read(json).map((_) => _.value);

  @override
  String toString() => expression;
}

typedef Transformer = Iterable<JsonPathMatch> Function(
    Iterable<JsonPathMatch> matches);
