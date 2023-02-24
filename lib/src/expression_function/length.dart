import 'package:json_path/src/expression_function/expression_function.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/match_mapper.dart';
import 'package:json_path/src/match_set.dart';
import 'package:json_path/src/nothing.dart';

class Length implements ExpressionFunction {
  Length(this._args) {
    if (_args.length != 1) {
      // TODO: exception type should be different. ArgumentError maybe?
      throw FormatException('Wrong number of arguments');
    }
    final arg = _args.single;
    if (!_isSupportedArgument(arg)) {
      throw FormatException('Invalid argument type');
    }
  }

  bool _isSupportedArgument(arg) =>
      arg is MatchMapper || arg is String || arg is List;

  final Iterable _args;

  @override
  apply(JsonPathMatch match) {
    final value = _resolve2(_args.single, match);
    if (value is String) return value.length;
    if (value is List) return value.length;
    if (value is MatchSet) return value.length;
    return Nothing();
  }

  _resolve2(arg, JsonPathMatch match) {
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
}
