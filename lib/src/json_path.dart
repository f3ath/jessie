import 'package:jessie/src/ast.dart';
import 'package:jessie/src/filter.dart';
import 'package:jessie/src/match.dart';
import 'package:jessie/src/root.dart';
import 'package:jessie/src/state.dart';
import 'package:jessie/src/tokenize.dart';

class JsonPath {
  factory JsonPath(String expression) {
    State state = Ready(Root());
    for (final node in Node.build(tokenize(expression)).children) {
      state = state.process(node);
    }
    return JsonPath._(state.filter);
  }

  JsonPath._(this._filter);

  final Filter _filter;

  /// Filters the given [json].
  /// Returns an Iterable of all elements found
  Iterable<PathMatch> filter(json) => _filter.call([PathMatch(json, '')]);

  @override
  String toString() => _filter.toString();
}
