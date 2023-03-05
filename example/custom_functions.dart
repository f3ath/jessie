import 'dart:convert';

import 'package:json_path/functions.dart';
import 'package:json_path/json_path.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

void main() {
  // Adding a custom function isObject() to select all objects

  final parser = JsonPathParser(userFunctions: [IsObject()]);
  final jsonPath = parser.parse(r'$[?is_object(@)]');

  final json = '[1, "foo", [1, 2], {}, {"foo": "bar"}, null]';
  jsonPath.readValues(jsonDecode(json)).forEach(print);
}

class IsObject implements Fun<bool> {
  @override
  final name = 'is_object';

  @override
  Expression<bool> withArgs(List<Expression> args) {
    // We only expect one argument.
    if (args.length != 1) throw FormatException('Exactly one arg expected');
    return args.single.map((value) {
      // is_object() does not apply to the result of logical expressions
      if (value is bool) return false;
      if (value is Maybe) {
        return value.type<Map>().map((_) => true).or(false);
      } else if (value is Nodes) {
        return value.asValue.type<Map>().map((_) => true).or(false);
      }
      throw FormatException('Unexpected arg type');
    });
  }
}
