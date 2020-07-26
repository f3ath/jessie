import 'dart:convert';
import 'dart:io';

import 'package:jessie/jessie.dart';
import 'package:test/test.dart';

void main() {
  final store = jsonDecode(File('test/store.json').readAsStringSync());
  group('Basic expressions', () {
    test('Empty', () {
      final path = JsonPath('');
      expect(path.toString(), r'$');
      expect(path.filter(store).single.value, store);
      expect(path.filter(store).single.path, r'$');
    });

    test('Only root', () {
      final path = JsonPath(r'$');
      expect(path.toString(), r'$');
      expect(path.filter(store).single.value, store);
      expect(path.filter(store).single.path, r'$');
    });

    test('Single field', () {
      final path = JsonPath(r'$.store');
      expect(path.toString(), r"$['store']");
      expect(path.filter(store).single.value, store['store']);
      expect(path.filter(store).single.path, r"$['store']");
    });

    test('Path with an index', () {
      final path = JsonPath(r'$.store.book[0].title');
      expect(path.toString(), r"$['store']['book'][0]['title']");
      expect(path.filter(store).single.value, 'Sayings of the Century');
      expect(path.filter(store).single.path, r"$['store']['book'][0]['title']");
    });
  });
}
