import 'package:json_path/src/ast/ast.dart';
import 'package:json_path/src/ast/tokenize.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/parsing_state.dart';
import 'package:json_path/src/predicate.dart';
import 'package:json_path/src/selector/root.dart';
import 'package:json_path/src/selector/selector.dart';

/// A JSONPath expression
class JsonPath {
  /// Creates an instance from string. The [expression] is parsed once, and
  /// the instance may be used many times after that.
  ///
  /// The [filter] arguments may contain the named filters used
  /// in the [expression].
  ///
  /// Throws [FormatException] if the [expression] can not be parsed.
  factory JsonPath(String expression, {Map<String, Predicate> filter}) {
    if (expression.isEmpty) throw FormatException('Empty expression');
    ParsingState state = Ready(RootSelector());
    AST(tokenize(expression)).nodes.forEach((node) {
      state = state.process(node, filter ?? {});
    });
    return JsonPath._(state.selector);
  }

  JsonPath._(this._selector);

  final Selector _selector;

  /// Reads the given [json] object returning an Iterable of all matches found.
  Iterable<JsonPathMatch> read(json) =>
      _selector.read([JsonPathMatch(json, '')]);

  /// Returns a copy of [json] with all matching values replaced with [value].
  dynamic set(dynamic json, dynamic value) =>
      _selector.set(json, (_) => value);

  @override
  String toString() => _selector.expression();
}
