import 'dart:convert';
import 'dart:io';

import 'package:jessie/jessie.dart';
import 'package:test/test.dart';

void main() {
  final json = jsonDecode(File('test/store.json').readAsStringSync());
  group('Basic expressions', () {
    test('Empty', () {
      final empty = JsonPath('');
      expect(empty.toString(), r'$');
      expect(empty.select(json).single.value, json);
      expect(empty.select(json).single.path, r'$');
    });

    test('Only root', () {
      final root = JsonPath(r'$');
      expect(root.toString(), r'$');
      expect(root.select(json).single.value, json);
      expect(root.select(json).single.path, r'$');
    });

    test('Single field', () {
      final store = JsonPath(r'$.store');
      expect(store.toString(), r"$['store']");
      expect(store.select(json).single.value, json['store']);
      expect(store.select(json).single.path, r"$['store']");
    });

    test('Path with an index', () {
      final firstBookTitle = JsonPath(r'$.store.book[0].title');
      expect(firstBookTitle.toString(), r"$['store']['book'][0]['title']");
      expect(
          firstBookTitle.select(json).single.value, 'Sayings of the Century');
      expect(firstBookTitle.select(json).single.path,
          r"$['store']['book'][0]['title']");
    });

    test('All in array', () {
      final allBooksInStore = JsonPath(r'$.store.book[*]');
      expect(allBooksInStore.toString(), r"$['store']['book'][*]");
      expect(allBooksInStore.select(json).length, 4);
      expect(
          allBooksInStore.select(json).first.value, json['store']['book'][0]);
      expect(allBooksInStore.select(json).first.path, r"$['store']['book'][0]");
      expect(allBooksInStore.select(json).last.value, json['store']['book'][3]);
      expect(allBooksInStore.select(json).last.path, r"$['store']['book'][3]");
    });

    test('Recursive', () {
      final everything = JsonPath(r'$..');
      expect(everything.toString(), r'$..');
      expect(everything.select(json).length, 8);
      expect(everything.select(json).first.value, json);
      expect(everything.select(json).first.path, r'$');
      expect(everything.select(json).last.value, json['store']['bicycle']);
      expect(everything.select(json).last.path, r"$['store']['bicycle']");
    });
  });
}
