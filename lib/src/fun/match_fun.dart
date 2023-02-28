import 'package:json_path/src/fun/fun_factory.dart';
import 'package:json_path/src/fun/type_system.dart';
import 'package:json_path/src/node.dart';
import 'package:json_path/src/node_mapper.dart';
import 'package:json_path/src/parser/types.dart';
import 'package:json_path/src/static_node_mapper.dart';

class MatchFun {
  MatchFun(this._value, this._regExp, this._matchSubstring);

  final NodesOrValue _regExp;
  final NodesOrValue _value;
  final bool _matchSubstring;

  LogicalType apply(Node node) {
    final value = _value.resolve(node);
    final regExp = _regExp.resolve(node);
    if (value is Nothing || regExp is Nothing) return LogicalType(false);

    final v = value.value;
    final r = regExp.value;
    if (v is String && r is String) {
      final prefix = _matchSubstring ? '' : r'^';
      final suffix = _matchSubstring ? '' : r'$';
      try {
        return LogicalType(RegExp(prefix + r + suffix).hasMatch(v));
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
  LogicalExpression makeFun(List args) {
    InvalidArgCount.check(name, args, 2);

    final value = args.first;
    final regex = args.last;
    if (value is StaticNodeMapper &&
        value.value is! Nothing &&
        value.value.value is! String) {
      throw FormatException('Invalid value');
    }
    if (regex is StaticNodeMapper &&
        regex.value is! Nothing &&
        regex.value.value is! String) {
      throw FormatException('Invalid value');
    }
    return NodeMapper(MatchFun(NodesOrValue(value), NodesOrValue(regex), matchSubstring)
        .apply);
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

/// TODO: rename this
class NodesOrValue {
  NodesOrValue(this._v) {
    _checkType(_v);
  }

  static void _checkType(v) {
    if (!(v is NodesType ||
        v is ValueType ||
        v is NodesExpression ||
        v is ValueExpression)) {
      throw ArgumentError('Invalid type of $v: (${v.runtimeType}');
    }
  }

  final Object _v;

  ValueType resolve(Node node) => _resolve(_v, node);

  ValueType _resolve(dynamic v, Node node) {
    if (v is ValueType) return v;
    if (v is NodesType) return v.asValue;
    if (v is ValueExpression) return v.apply(node);
    if (v is NodesExpression) return v.apply(node).asValue;
    throw StateError('Invalid type ${v.runtimeType}');
  }
}
