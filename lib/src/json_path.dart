import 'package:json_path/src/ast.dart';
import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/root.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/state.dart';
import 'package:json_path/src/tokenize.dart';

/// A JSONPath expression
class JsonPath {
  /// Creates an instance from string
  factory JsonPath(String expression) {
    if (expression.isEmpty) throw FormatException('Empty expression');
    State state = Ready(Root());
    for (final node in Node.list(tokenize(expression))) {
      state = state.process(node);
    }
    return JsonPath._(state.selector);
  }

  JsonPath._(this._selector);

  final Selector _selector;

  /// Filters the given [json] object.
  /// Returns an Iterable of all elements found
  Iterable<Result> select(json) => _selector([Result(json, '')]);

  @override
  String toString() => _selector.toString();
}
