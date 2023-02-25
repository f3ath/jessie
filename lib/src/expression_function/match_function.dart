import 'package:json_path/src/expression_function/expression_function.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/match_mapper.dart';
import 'package:json_path/src/match_set.dart';

class MatchFunction implements ExpressionFunction<bool> {
  MatchFunction(this._value, this._regExp, this._matchSubstring);

  static MatchFunction fromArgs(List args, {bool matchSubstring = false}) {
    if (args.length != 2) {
      // TODO: exception type should be different. ArgumentError maybe?
      throw FormatException('Wrong number of arguments');
    }
    final value = args.first;
    final regex = args.last;
    if (value is! MatchMapper && value is! String) {
      throw FormatException('Invalid argument type');
    }
    if (regex is! MatchMapper && regex is! String) {
      throw FormatException('Invalid argument type');
    }
    return MatchFunction(value, regex, matchSubstring);
  }

  final Object _regExp;
  final Object _value;
  final bool _matchSubstring;

  _resolve2(Object arg, JsonPathMatch match) {
    if (arg is MatchMapper) {
      return _resolve(arg(match));
    }
    return arg;
  }

  _resolve(value) {
    if (value is MatchSet && value.length == 1) {
      value = value.value;
    }
    return value;
  }

  @override
  bool apply(JsonPathMatch match) {
    final value = _resolve2(_value, match);
    final regExp = _resolve2(_regExp, match);

    if (value is String && regExp is String) {
      final prefix = _matchSubstring ? '' : r'^';
      final suffix = _matchSubstring ? '' : r'$';
      try {
        return RegExp(prefix + regExp + suffix).hasMatch(value);
      } on FormatException {
        return false;
      }
    }
    return false;
  }
}
