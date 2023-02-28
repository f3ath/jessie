import 'package:json_path/src/fun/fun_factory.dart';
import 'package:json_path/src/fun/types/logical.dart';
import 'package:json_path/src/fun/types/logical_expression.dart';
import 'package:json_path/src/fun/types/nodes_expression.dart';
import 'package:json_path/src/fun/types/value.dart';
import 'package:json_path/src/fun/types/value_expression.dart';
import 'package:json_path/src/node.dart';
import 'package:json_path/src/node_mapper.dart';
import 'package:json_path/src/static_node_mapper.dart';

class MatchFunFactory extends _CommonFactory {
  @override
  final name = 'match';
  @override
  final substring = false;
}

class SearchFunFactory extends _CommonFactory {
  @override
  final name = 'search';
  @override
  final substring = true;
}

abstract class _CommonFactory implements FunFactory<Logical> {
  bool get substring;

  @override
  LogicalExpression makeFun(List<NodeMapper> args) {
    InvalidArgCount.check(name, args, 2);

    final value = args.first;
    final regex = args.last;

    // Static type checking
    _checkStaticTypes(value);
    _checkStaticTypes(regex);

    if (value is StaticNodeMapper<Value> && regex is StaticNodeMapper<Value>) {
      return regex.value
          .flatMap(value.value, (r, v) => _match(r, v, substring))
          .map(Logical.new)
          .map(StaticNodeMapper.new)
          .orElse(() => throw FormatException('Invalid value'));
    }

    return NodeMapper((node) {
      final v = _resolve(value, node);
      final r = _resolve(regex, node);

      return Logical(v
          .map((v) => r.map((r) {
                if (v is String && r is String) {
                  try {
                    return _match(r, v, substring);
                  } on FormatException {
                    return false;
                  }
                }
                return false;
              }).orElse(() => false))
          .orElse(() => false));
    });
  }

  void _checkStaticTypes(value) {
    if (value is StaticNodeMapper<Value>) {
      value.value
          .whereType<String>()
          .orElse(() => throw FormatException('Invalid type'));
    }
  }

  Value _resolve(NodeMapper v, Node node) {
    if (v is ValueExpression) return v.apply(node);
    if (v is NodesExpression) return v.apply(node).asValue;
    throw StateError('Invalid type ${v.runtimeType}');
  }

  bool _match(String regExp, String string, bool substring) =>
      RegExp(substring ? regExp : '^$regExp\$').hasMatch(string);
}
