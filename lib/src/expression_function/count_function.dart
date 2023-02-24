import 'package:json_path/src/expression_function/expression_function.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/match_mapper.dart';
import 'package:json_path/src/match_set.dart';

class CountFunction implements ExpressionFunction {
  CountFunction(this._arg);

  static CountFunction fromArgs(List args) {
    if (args.length != 1) {
      // TODO: exception type should be different. ArgumentError maybe?
      throw FormatException('Wrong number of arguments');
    }
    final arg = args.single;
    if (arg is! MatchMapper<MatchSet>) {
      throw FormatException('Invalid argument type');
    }
    return CountFunction(arg);
  }

  final MatchMapper<MatchSet> _arg;

  @override
  apply(JsonPathMatch match) => _arg(match).length;
}
