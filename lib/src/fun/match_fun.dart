import 'package:json_path/src/fun/fun_factory.dart';
import 'package:json_path/src/fun/types/logical.dart';
import 'package:json_path/src/fun/types/logical_expression.dart';
import 'package:json_path/src/fun/types/nodes_expression.dart';
import 'package:json_path/src/fun/types/value.dart';
import 'package:json_path/src/fun/types/value_expression.dart';
import 'package:json_path/src/node.dart';
import 'package:json_path/src/node_mapper.dart';
import 'package:json_path/src/static_node_mapper.dart';

class MatchFunFactory extends StringMatchingFunFactory {
  MatchFunFactory() : super('match', false);
}

class SearchFunFactory extends StringMatchingFunFactory {
  SearchFunFactory() : super('search', true);
}

class Arg {
  Arg(this.value, this.regex);

  final NodeMapper regex;
  final NodeMapper value;
}

abstract class StringMatchingFunFactory extends FunFactory<Logical, Arg> {
  StringMatchingFunFactory(String name, this.substring) : super(name, 2);

  final bool substring;

  @override
  Arg convertArgs(List<NodeMapper> args) => Arg(args[0], args[1]);

  @override
  LogicalExpression apply(Arg arg) {
    final value = arg.value;
    final regex = arg.regex;

    // Static type checking and extraction
    final staticValue = _getStaticValue(value);
    final staticRegex = _getStaticValue(regex);

    // If all args are available statically,
    // we can return the result right away.
    if (staticValue != null && staticRegex != null) {
      final hasMatch = _match(staticRegex, staticValue, substring);
      return StaticNodeMapper(Logical(hasMatch));
    }

    return NodeMapper((node) {
      final v = _resolve(value, node);
      final r = _resolve(regex, node);
      final hasMatch = v
          .map((v) => r
              .map((r) => _typeSafeMatch(v, r, substring))
              .orElse(() => false)) // Regex is Nothing
          .orElse(() => false); // Value is nothing
      return Logical(hasMatch);
    });
  }

  /// Returns the value if it is available at parse time.
  String? _getStaticValue(value) {
    if (value is StaticNodeMapper<Value>) {
      return value.value
          .whereType<String>()
          .orElse(() => throw FormatException('Invalid type'));
    }
    return null;
  }

  Value _resolve(NodeMapper v, Node node) {
    if (v is ValueExpression) return v.applyTo(node);
    if (v is NodesExpression) return v.applyTo(node).asValue;
    throw ArgumentError('Invalid type ${v.runtimeType}');
  }

  bool _typeSafeMatch(value, regex, bool substring) {
    if (value is! String || regex is! String) return false;
    try {
      return _match(regex, value, substring);
    } on FormatException {
      return false; // Invalid regex
    }
  }

  bool _match(String regExp, String string, bool substring) =>
      RegExp(substring ? regExp : '^$regExp\$').hasMatch(string);
}
