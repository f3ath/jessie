import 'package:json_path/src/parser.dart';
import 'package:json_path/src/predicate.dart';
import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';

/// A JSONPath expression
class JsonPath {
  /// Creates an instance from string
  JsonPath(String expression, {Map<String, Predicate> filter})
      : _selector = const Parser().parse(expression, filter ?? {});

  final Selector _selector;

  /// Filters the given [json] object.
  /// Returns an Iterable of all elements found
  Iterable<Result> filter(json) => _selector.filter([Result(json, '')]);

  @override
  String toString() => _selector.expression();
}
