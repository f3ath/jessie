import 'package:json_path/src/json_path_match.dart';

class MatchingContext {
  const MatchingContext(this.expression, this.filter);

  /// JSON Path expression
  final String expression;

  /// Named callback filters
  final Map<String, CallbackFilter> filter;
}
