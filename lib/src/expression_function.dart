import 'package:json_path/json_path.dart';
import 'package:json_path/src/match_set.dart';
import 'package:json_path/src/nothing.dart';

abstract class ExpressionFunction {
  apply(JsonPathMatch match);
}

class LengthFunction extends ExpressionFunction {
  LengthFunction(this._args) {
    if (_args.length != 1) {
      // TODO: exception type should be different. ArgumentError maybe?
      throw FormatException('Wrong number of arguments');
    }
  }

  final Iterable _args;

  @override
  apply(JsonPathMatch match) {
    final value = _resolve(_args.single(match));
    if (value is String) return value.length;
    if (value is List) return value.length;
    if (value is MatchSet) return value.length;
    return Nothing();
  }

  _resolve(value) {
    if (value is MatchSet && value.length == 1) {
      value = value.value;
    }
    return value;
  }
}
