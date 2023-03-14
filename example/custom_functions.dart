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
class IsObject implements Fun1<bool, Maybe> {
  @override
  final name = 'is_object';

  @override
  Expression<bool> apply(Expression<Maybe> arg) {
      return arg.map((v) => v.map(_isMap).or(false));
  }

  bool _isMap(v) => v is Map;
}
