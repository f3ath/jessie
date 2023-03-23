import 'package:json_path/src/fun/fun.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

abstract class StringMatcher implements Fun2<bool, Maybe, Maybe> {
  const StringMatcher(this.name, this.allowSubstring);

  @override
  final String name;

  final bool allowSubstring;

  @override
  bool call(Maybe value, Maybe regex) =>
      value.merge(regex, _typeSafeMatch).or(false);

  bool _typeSafeMatch(value, regex) {
    if (value is! String || regex is! String) return false;
    try {
      return _makeRegex(regex).hasMatch(value);
    } on FormatException {
      return false; // Invalid regex means no match
    }
  }

  RegExp _makeRegex(String regex) =>
      RegExp(allowSubstring ? regex : '^$regex\$');
}
