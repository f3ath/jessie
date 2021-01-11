import 'package:json_path/src/path/json_path_match.dart';

class MatchingContext {
  const MatchingContext(this.expression, this.filters);

  /// JSON Path expression
  final String expression;

  /// Named callback filters
  final Map<String, CallbackFilter> filters;
}
