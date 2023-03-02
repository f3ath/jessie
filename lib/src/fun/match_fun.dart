import 'package:json_path/src/fun/fun_factory.dart';
import 'package:json_path/src/fun/types/bool_expression.dart';
import 'package:json_path/src/fun/types/nodes_expression.dart';
import 'package:json_path/src/fun/types/value_expression.dart';
import 'package:json_path/src/node.dart';
import 'package:json_path/src/node_mapper.dart';
import 'package:json_path/src/static_node_mapper.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

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

abstract class StringMatchingFunFactory extends FunFactory<bool, Arg> {
  StringMatchingFunFactory(String name, this.substring) : super(name, 2);

  final bool substring;

  @override
  Arg convertArgs(List<NodeMapper> args) => Arg(args[0], args[1]);

  @override
  BoolExpression apply(Arg arg) {
    final value = arg.value;
    final regex = arg.regex;

    // Static type checking and extraction
    final staticValue = _getStaticValue(value);
    final staticRegex = _getStaticValue(regex);

    // If all args are available statically,
    // we can return the result right away.
    if (staticValue != null && staticRegex != null) {
      final hasMatch = _match(staticRegex, staticValue, substring);
      return StaticNodeMapper(hasMatch);
    }

    return NodeMapper((node) {
      final v = _resolve(value, node);
      final r = _resolve(regex, node);
      final hasMatch = v
          .map((v) => r
              .map((r) => _typeSafeMatch(v, r, substring))
              .or(false)) // Regex is Nothing
          .or(false); // Value is nothing
      return hasMatch;
    });
  }

  /// Returns the value if it is available at parse time.
  String? _getStaticValue(value) {
    if (value is StaticNodeMapper<Maybe>) {
      return value.value
          .type<String>()
          .orThrow(() => FormatException('Invalid type'));
    }
    return null;
  }

  Maybe _resolve(NodeMapper v, Node node) {
    if (v is ValueExpression) return v.applyTo(node);
    if (v is NodesExpression) return v.applyTo(node).asValue;
    return Nothing();
    // throw ArgumentError('Invalid type ${v.runtimeType}');
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
