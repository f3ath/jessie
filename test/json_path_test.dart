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

    test('All values', () {
      final allInRoot = JsonPath(r'$.*');
      expect(allInRoot.toString(), r'$.*');
      expect(allInRoot.select(json).single.value, json['store']);
      expect(allInRoot.select(json).single.path, r"$['store']");

      final allInStore = JsonPath(r'$.store.*');
      expect(allInStore.toString(), r"$['store'].*");
      expect(allInStore.select(json).length, 2);
      expect(allInStore.select(json).first.value, json['store']['book']);
      expect(allInStore.select(json).first.path, r"$['store']['book']");
      expect(allInStore.select(json).last.value, json['store']['bicycle']);
      expect(allInStore.select(json).last.path, r"$['store']['bicycle']");
    });

    test('Recursive', () {
      final allNode = JsonPath(r'$..');
      expect(allNode.toString(), r'$..');
      expect(allNode.select(json).length, 8);
      expect(allNode.select(json).first.value, json);
      expect(allNode.select(json).first.path, r'$');
      expect(allNode.select(json).last.value, json['store']['bicycle']);
      expect(allNode.select(json).last.path, r"$['store']['bicycle']");
    });

    test('Recursive with all fields', () {
      final allValues = JsonPath(r'$..*');
      expect(allValues.toString(), r'$..*');
      expect(allValues.select(json).length, 27);
      expect(allValues.select(json).first.value, json['store']);
      expect(allValues.select(json).first.path, r"$['store']");
      expect(
          allValues.select(json).last.value, json['store']['bicycle']['price']);
      expect(
          allValues.select(json).last.path, r"$['store']['bicycle']['price']");
    });
  });
}
