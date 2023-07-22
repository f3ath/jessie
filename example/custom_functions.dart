import 'dart:convert';

import 'package:json_path/fun_sdk.dart';
import 'package:json_path/json_path.dart';

/// This example shows how to create and use a custom function.
void main() {
  final parser = JsonPathParser(functions: [IsPalindrome()]);
  final jsonPath = parser.parse(r'$[?is_palindrome(@)]');
  final json = jsonDecode('["madam", "foo", "nurses run", 42, {"A": "B"}]');
  jsonPath.readValues(json).forEach(print);
}

/// An implementation of a palindrome test.
class IsPalindrome implements Fun1<bool, Maybe> {
  @override
  final name = 'is_palindrome';

  @override
  bool call(Maybe arg) => arg
      .type<String>() // Make sure it's a string
      .map((value) => value.replaceAll(' ', '')) // drop spaces
      .map((value) => value.split('').reversed.join() == value) // palindrome?
      .or(false); // for non-string values return false
}
