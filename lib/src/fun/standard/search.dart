import 'package:json_path/src/fun/standard/string_matcher.dart';

/// The standard `search()` function which returns `true` if
/// the value contains a substring which matches the regex.
/// The regex must be a valid [I-Regexp](https://datatracker.ietf.org/doc/draft-ietf-jsonpath-iregexp/)
/// expression, otherwise the function returns `false` regardless of the value.
/// See https://ietf-wg-jsonpath.github.io/draft-ietf-jsonpath-base/draft-ietf-jsonpath-base.html#name-search-function-extension
class Search extends StringMatcher {
  const Search() : super('search', true);
}
