import 'dart:convert';

import 'package:json_path/fun_sdk.dart';
import 'package:json_path/json_path.dart';

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
  bool call(v) => v.map((v) => v is Map).or(false);
}
