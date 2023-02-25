import 'package:json_path/src/grammar/json_path.dart';
import 'package:json_path/src/node.dart';
import 'package:json_path/src/root_node.dart';
import 'package:json_path/src/selector.dart';

/// A JSONPath expression
class JsonPath {
  /// Creates an instance from string. The [expression] is parsed once, and
  /// the instance may be used many times after that.
  ///
  /// The [filters] map is used to provide named callback filters.
  /// Example:
  /// ```dart
  /// /// Select all elements with price under 20
  /// final path = JsonPath(r'$.store..[?discounted]', filters: {
  /// 'discounted': (match) =>
  ///     match.value is Map && match.value['price'] is num && match.value['price'] < 20
  /// });
  /// ```
  ///
  /// The [_algebra] is used to operate with values in evaluated expressions.
  /// The expression support is limited, you are encouraged to use the named callback
  /// filters instead. JSONPath expression evaluation is a grey area
  /// since the behavior differs per implementation. The relaxed algebra,
  /// which is the default, implements a reasonably relaxed set of rules,
  /// allowing, for instance, mixed-type ordering.
  ///
  /// Throws [FormatException] if the [expression] can not be parsed.
  JsonPath(this.expression) : _selector = jsonPath.parse(expression).value;

  final Selector _selector;

  /// JSONPath expression.
  final String expression;

  /// Reads the given [document] object returning an Iterable of all matches found.
  Iterable<Node> read(document) => _selector.apply(RootNode(document));

  /// Reads the given [json] object returning an Iterable of all values found.
  Iterable readValues(json) => read(json).map((_) => _.value);

  @override
  String toString() => expression;
}
