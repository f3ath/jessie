import 'package:json_path/src/json_path_match.dart';

class MatchingContext {
  const MatchingContext(this.filters);

  /// Named callback filters
  final Map<String, CallbackFilter> filters;
}
