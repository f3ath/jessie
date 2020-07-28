import 'package:jessie/src/ast.dart';
import 'package:jessie/src/selector/selector.dart';
import 'package:jessie/src/selector/root.dart';
import 'package:jessie/src/result.dart';
import 'package:jessie/src/state.dart';
import 'package:jessie/src/tokenize.dart';

class JsonPath {
  factory JsonPath(String expression) {
    State state = Ready(Root());
    for (final node in Node.build(tokenize(expression)).children) {
      state = state.process(node);
    }
    return JsonPath._(state.selector);
  }

  JsonPath._(this._selector);

  final Selector _selector;

  /// Filters the given [json].
  /// Returns an Iterable of all elements found
  Iterable<Result> select(json) => _selector([Result(json, '')]);

  @override
  String toString() => _selector.toString();
}
