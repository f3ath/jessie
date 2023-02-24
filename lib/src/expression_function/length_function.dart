import 'package:json_path/src/expression_function/expression_function.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/match_mapper.dart';
import 'package:json_path/src/match_set.dart';
import 'package:json_path/src/nothing.dart';

class LengthFunction implements ExpressionFunction {
  LengthFunction(this._arg);

  static LengthFunction fromArgs(Iterable args) {
    if (args.length != 1) {
      // TODO: exception type should be different. ArgumentError maybe?
      throw FormatException('Wrong number of arguments');
    }
    final arg = args.single;
    if (!_isSupportedArgument(arg)) {
      throw FormatException('Invalid argument type');
    }
    return LengthFunction(arg);
  }

  static bool _isSupportedArgument(arg) =>
      arg is MatchMapper || arg is String || arg is List;

  final Object _arg;

  @override
  apply(JsonPathMatch match) {
    final value = _resolve2(_arg, match);
    if (value is String) return value.length;
    if (value is List) return value.length;
    if (value is MatchSet) return value.length;
    return Nothing();
  }

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
}
