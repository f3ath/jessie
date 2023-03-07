import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/expression/expression_ext.dart';
import 'package:json_path/src/expression/static_expression.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

abstract class StringMatchingFun implements Fun<bool> {
  const StringMatchingFun(this.name, this.substring);

  @override
  final String name;

  final bool substring;

  @override
  Expression<bool> toExpression(List<Expression> args) {
    if (args.length != 2) throw Exception('Invalid args');
    final value = args[0];
    final regex = args[1];

    // Static type checking and extraction
    final staticValue = _getStaticValue(value);
    final staticRegex = _getStaticValue(regex);

    // If all args are available statically,
    // we can return the result right away.
    if (staticValue != null && staticRegex != null) {
      return StaticExpression(_match(staticRegex, staticValue, substring));
    }

    return Expression((node) {
      final v = value.resolveToValue(node);
      final r = regex.resolveToValue(node);
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
    if (value is StaticExpression<Maybe>) {
      return value.value
          .type<String>()
          .orThrow(() => FormatException('Invalid type'));
    }
    return null;
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
