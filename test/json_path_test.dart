import 'dart:convert';
import 'dart:io';

import 'package:jessie/jessie.dart';
import 'package:test/test.dart';

void main() {
  final json = jsonDecode(File('test/store.json').readAsStringSync());
  group('Basic expressions', () {
    test('Empty', () {
      final path = JsonPath('');
      expect(path.toString(), r'$');
      expect(path.select(json).single.value, json);
      expect(path.select(json).single.path, r'$');
    });

    test('Only root', () {
      final path = JsonPath(r'$');
      expect(path.toString(), r'$');
      expect(path.select(json).single.value, json);
      expect(path.select(json).single.path, r'$');
    });

    test('Single field', () {
      final path = JsonPath(r'$.store');
      expect(path.toString(), r"$['store']");
      expect(path.select(json).single.value, json['store']);
      expect(path.select(json).single.path, r"$['store']");
    });

    test('Path with an index', () {
      final path = JsonPath(r'$.store.book[0].title');
      expect(path.toString(), r"$['store']['book'][0]['title']");
      expect(path.select(json).single.value, 'Sayings of the Century');
      expect(path.select(json).single.path, r"$['store']['book'][0]['title']");
    });

    test('All in array', () {
      final path = JsonPath(r'$.store.book[*]');
      expect(path.toString(), r"$['store']['book'][*]");
      expect(path.select(json).length, 4);
      expect(path.select(json).first.value, json['store']['book'][0]);
      expect(path.select(json).first.path, r"$['store']['book'][0]");
      expect(path.select(json).last.value, json['store']['book'][3]);
      expect(path.select(json).last.path, r"$['store']['book'][3]");
    });
  });
}
