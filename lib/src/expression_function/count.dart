import 'package:json_path/src/expression_function/expression_function.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/match_mapper.dart';
import 'package:json_path/src/match_set.dart';
import 'package:json_path/src/nothing.dart';

class Count implements ExpressionFunction {
  Count(this._args) {
    if (_args.length != 1) {
      // TODO: exception type should be different. ArgumentError maybe?
      throw FormatException('Wrong number of arguments');
    }
    final arg = _args.single;
    if (arg is! MatchMapper) {
      throw FormatException('Invalid argument type');
    }
  }

  final Iterable _args;

  @override
  apply(JsonPathMatch match) {
    final value = _args.single(match);
    if (value is MatchSet) return value.length;
    return Nothing();
  }
}
