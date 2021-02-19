import 'package:json_path/src/filter_not_found.dart';
import 'package:json_path/src/json_path_match.dart';

class MatchingContext {
  const MatchingContext(this._filters);

  /// Named callback filters
  final Map<String, CallbackFilter> _filters;

  CallbackFilter getFilter(String name) {
    final filter = _filters[name];
    if (filter == null) {
      throw FilterNotFound('Callback filter "$name" not found');
    }
    return filter;
  }
}
