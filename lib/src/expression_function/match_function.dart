import 'package:json_path/src/expression_function/expression_function.dart';
import 'package:json_path/src/expression_function/resolvable.dart';
import 'package:json_path/src/expression_function/types.dart';
import 'package:json_path/src/node.dart';
import 'package:json_path/src/types/node_mapper.dart';

class MatchFunction implements ExpressionFunction<LogicalType> {
  MatchFunction(this._value, this._regExp, this._matchSubstring);

  static MatchFunction fromArgs(List args, {bool matchSubstring = false}) {
    if (args.length != 2) {
      // TODO: exception type should be different. ArgumentError maybe?
      throw FormatException('Wrong number of arguments');
    }
    final value = args.first;
    final regex = args.last;
    if (value is! NodeMapper && value is! String) {
      throw FormatException('Invalid argument type');
    }
    if (regex is! NodeMapper && regex is! String) {
      throw FormatException('Invalid argument type');
    }
    return MatchFunction(Resolvable(value), Resolvable(regex), matchSubstring);
  }

  final Resolvable _regExp;
  final Resolvable _value;
  final bool _matchSubstring;

  @override
  LogicalType apply(Node node) {
    final value = _value.resolve(node);
    final regExp = _regExp.resolve(node);

    if (value is String && regExp is String) {
      final prefix = _matchSubstring ? '' : r'^';
      final suffix = _matchSubstring ? '' : r'$';
      try {
        return RegExp(prefix + regExp + suffix).hasMatch(value).asLogicalType;
      } on FormatException {
        return false.asLogicalType;
      }
    }
    return false.asLogicalType;
  }
}
