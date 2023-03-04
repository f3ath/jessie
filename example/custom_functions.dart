// import 'dart:convert';

// import 'package:json_path/functions.dart';
// import 'package:json_path/json_path.dart';
// import 'package:maybe_just_nothing/maybe_just_nothing.dart';
//
// void main() {
//   // Addind a custom function isObject() to select all objects
//   final json = '[1, "foo", [1, 2], {}, {"foo": "bar"}, null]';
//   JsonPath(r'$[?isObject(@)]').readValues(jsonDecode(json)).forEach(print);
// }
//
// class IsObjectFun implements Fun<bool> {
//   @override
//   final name = 'isObject';
//
//   @override
//   Expression<bool> withArgs(List<Expression> args) {
//     if (args.length != 1) throw FormatException('Exactly one arg expected');
//     final arg = args.single;
//     return arg.map((value) {
//       if (value is bool) return false;
//       if (value is Maybe) {
//         return value.type<Map>().map((_) => true).or(false);
//       } else if (value is Nodes) {
//         return value.asValue.type<Map>().map((_) => true).or(false);
//       }
//       throw FormatException('Unexpected arg type');
//     });
//   }
// }
