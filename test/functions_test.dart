import 'dart:convert';
import 'dart:io';

import 'package:json_path/fun_extra.dart';
import 'package:json_path/json_path.dart';
import 'package:test/test.dart';

void main() {
  final store = jsonDecode(File('test/store.json').readAsStringSync());
  final parser = JsonPathParser(functions: [
    Reverse(),
    Siblings(),
    Xor(),
  ]);
  group('User-defined functions', () {
    test('Fun<Nodes> in Nodes context', () {
      expect(
          parser
              .parse(r'$..[?count(siblings(siblings(@))) > 4]')
              .readValues(store)
              .length,
          equals(22));
    });
  });

  group('Logical', () {
    test('xor', () {
      final json = ['', 'a', 'ab', 'abc', 'aaa', 'bob'];
      expect(
        parser
            .parse(r'$[?xor(search(@, "a"), search(@, "b"))]')
            .readValues(json)
            .toList(),
        equals(['a', 'aaa', 'bob']),
      );
    });
  });

  test('function not found', () {
    expect(() => parser.parse(r'$[?foo(@) == 3]'), throwsFormatException);
  });
}
