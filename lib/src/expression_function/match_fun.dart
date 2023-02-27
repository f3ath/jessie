import 'package:json_path/src/expression_function/fun_factory.dart';
import 'package:json_path/src/expression_function/resolvable.dart';
import 'package:json_path/src/expression_function/types.dart';
import 'package:json_path/src/node.dart';
import 'package:json_path/src/types/node_mapper.dart';

class MatchFun {
  MatchFun(this._value, this._regExp, this._matchSubstring);

  final Resolvable _regExp;
  final Resolvable _value;
  final bool _matchSubstring;

  LogicalType apply(Node node) {
    final value = _value.resolve(node);
    final regExp = _regExp.resolve(node);

    if (value is String && regExp is String) {
      final prefix = _matchSubstring ? '' : r'^';
      final suffix = _matchSubstring ? '' : r'$';
      try {
        return LogicalType(RegExp(prefix + regExp + suffix).hasMatch(value));
      } on FormatException {
        return LogicalType(false);
      }
    }
    return LogicalType(false);
  }
}

abstract class _CommonFactory implements FunFactory<LogicalType> {
  bool get matchSubstring;

  @override
  NodeMapper<LogicalType> makeFun(List args) {
    InvalidArgCount.check(name, args, 2);

    final value = args.first;
    final regex = args.last;
    if (value is! NodeMapper && value is! String) {
      throw FormatException('Invalid argument type');
    }
    if (regex is! NodeMapper && regex is! String) {
      throw FormatException('Invalid argument type');
    }
    return MatchFun(Resolvable(value), Resolvable(regex), matchSubstring).apply;
  }
}

class MatchFunFactory extends _CommonFactory {
  @override
  final name = 'match';

  @override
  final matchSubstring = false;
}

class SearchFunFactory extends _CommonFactory {
  @override
  final name = 'search';
  @override
  final matchSubstring = true;
}
