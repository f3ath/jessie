import 'dart:convert';

import 'package:json_path/functions.dart';
import 'package:json_path/json_path.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

void main() {
  final parser = JsonPathParser(userFunctions: [IsObject()]);
  final jsonPath = parser.parse(r'$[?is_object(@)]');

  final json = '[1, "foo", [1, 2], {}, {"foo": "bar"}, null]';
  jsonPath.readValues(jsonDecode(json)).forEach(print);
}

/// Custom function implementation
class IsObject implements Fun<bool> {
  @override
  final name = 'is_object';

  @override
  Expression<bool> toExpression(List<Expression> args) {
    // We only expect one argument.
    if (args.length != 1) throw FormatException('Exactly one arg expected');
    final arg = args.single;
    if (arg is Expression<Maybe>) {
      return arg.map((v) => v.map(_isMap).or(false));
    }
    if (arg is Expression<Nodes>) {
      return arg.map((v) => v.asValue.map(_isMap).or(false));
    }
    throw FormatException('Invalid argument type');
  }

  bool _isMap(v) => v is Map;
}
