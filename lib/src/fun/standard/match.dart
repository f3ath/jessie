import 'package:json_path/src/fun/standard/string_matcher.dart';

/// The standard `match()` function which returns `true`
/// if the value matches the regex.
/// The regex must be a valid [I-Regexp](https://datatracker.ietf.org/doc/draft-ietf-jsonpath-iregexp/)
/// expression, otherwise the function returns `false` regardless of the value.
/// See https://ietf-wg-jsonpath.github.io/draft-ietf-jsonpath-base/draft-ietf-jsonpath-base.html#name-match-function-extension
class Match extends StringMatcher {
  const Match() : super('match', false);
}
