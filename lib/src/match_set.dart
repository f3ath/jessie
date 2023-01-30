import 'package:json_path/src/json_path_match.dart';

/// A set of zero or more [JsonPathMatch].
class MatchSet {
  MatchSet(this._matches);

  final Iterable<JsonPathMatch> _matches;

  /// True if there is exactly one match.
  bool get isSingular => _matches.length == 1;

  /// True if empty.
  bool get isEmpty => _matches.isEmpty;

  /// True if not empty.
  bool get isNotEmpty => _matches.isNotEmpty;

  /// The value of a singular set.
  get value => _matches.single.value;
}
