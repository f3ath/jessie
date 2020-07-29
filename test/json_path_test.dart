import 'dart:convert';
import 'dart:io';

import 'package:json_path/json_path.dart';
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

    test('Single field in bracket notation', () {
      final store = JsonPath(r"$['store']");
      expect(store.toString(), r"$['store']");
      expect(store.select(json).single.value, json['store']);
      expect(store.select(json).single.path, r"$['store']");
    });

    test('Mixed brackets and fields', () {
      final store = JsonPath(r"$['store'].bicycle['price']");
      expect(store.toString(), r"$['store']['bicycle']['price']");
      expect(store.select(json).single.value, json['store']['bicycle']['price']);
      expect(store.select(json).single.path, r"$['store']['bicycle']['price']");
    });
  });

  group('Wildcards', () {
    test('All in root', () {
      final allInRoot = JsonPath(r'$.*');
      expect(allInRoot.toString(), r'$.*');
      expect(allInRoot.select(json).single.value, json['store']);
      expect(allInRoot.select(json).single.path, r"$['store']");
    });

    test('All in store', () {
      final allInStore = JsonPath(r'$.store.*');
      expect(allInStore.toString(), r"$['store'].*");
      expect(allInStore.select(json).length, 2);
      expect(allInStore.select(json).first.value, json['store']['book']);
      expect(allInStore.select(json).first.path, r"$['store']['book']");
      expect(allInStore.select(json).last.value, json['store']['bicycle']);
      expect(allInStore.select(json).last.path, r"$['store']['bicycle']");
    });
  });

  group('Recursion', () {
    test('Recursive', () {
      final allNode = JsonPath(r'$..');
      expect(allNode.toString(), r'$..');
      expect(allNode.select(json).length, 8);
      expect(allNode.select(json).first.value, json);
      expect(allNode.select(json).first.path, r'$');
      expect(allNode.select(json).last.value, json['store']['bicycle']);
      expect(allNode.select(json).last.path, r"$['store']['bicycle']");
    });

    test('Recursive with all values', () {
      final path = JsonPath(r'$..*');
      expect(path.toString(), r'$..*');
      expect(path.select(json).length, 27);
      expect(path.select(json).first.value, json['store']);
      expect(path.select(json).first.path, r"$['store']");
      expect(path.select(json).last.value, json['store']['bicycle']['price']);
      expect(path.select(json).last.path, r"$['store']['bicycle']['price']");
    });

    test('Every price tag', () {
      final path = JsonPath(r'$..price');
      expect(path.toString(), r"$..['price']");
      expect(path.select(json).length, 5);
//      expect(path.select(json).first.value, json['store']);
//      expect(path.select(json).first.path, r"$['store']");
//      expect(path.select(json).last.value, json['store']['bicycle']['price']);
//      expect(path.select(json).last.path, r"$['store']['bicycle']['price']");
    });
  });

  group('Arrays', () {
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
