import 'dart:convert';
import 'dart:io';

import 'package:json_path/json_path.dart';
import 'package:test/test.dart';

void main() {
  final json = jsonDecode(File('test/store.json').readAsStringSync());
  group('Filtering', () {
    test('Simple', () {
      final path = JsonPath(r'$.store..[?discounted]', filters: {
        'discounted': (m) =>
            m.value is Map && m.value['price'] is num && m.value['price'] < 20
      });

      expect(path.toString(), r'$.store..[?discounted]');

      final matches = path.read(json);
      expect(matches.length, 4);
      expect(matches.first.value, json['store']['book'][0]);
      expect(matches.first.path, r"$['store']['book'][0]");
      expect(matches.last.value, json['store']['bicycle']);
      expect(matches.last.path, r"$['store']['bicycle']");
    });

    test('Can be applied to scalars, can access parent', () {
      final path = JsonPath(r'$.store..price[?low]', filters: {
        'low': (m) =>
            m.value is num &&
            m.value < 20 &&
            m.parent?.value['category'] == 'fiction'
      });

      expect(path.toString(), r'$.store..price[?low]');

      final matches = path.read(json);
      expect(matches.length, 2);
      expect(matches.first.value, json['store']['book'][1]['price']);
      expect(matches.first.path, r"$['store']['book'][1]['price']");
      expect(matches.last.value, json['store']['book'][2]['price']);
      expect(matches.last.path, r"$['store']['book'][2]['price']");
    });

    test('Missing filter', () {
      expect(
          () => JsonPath(r'$.store..[?discounted]').read(json),
          throwsA(predicate((e) =>
              e is FilterNotFound && e.toString().contains('discounted'))));
    });
  });
}
