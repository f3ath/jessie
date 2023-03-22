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

  void validateArg0(Maybe value) => value.ifPresent((it) {
        if (it is! String) {
          throw ArgumentError('String value expected');
        }
      });

  void validateArg1(Maybe regex) => regex.ifPresent((it) {
        if (it is! String) {
          throw ArgumentError('String regex expected');
        }
        _makeRegex(it); // Validate regex.
      });

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
