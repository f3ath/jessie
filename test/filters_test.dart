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
      expect(matches.first.value, json['store']['bicycle']);
      expect(matches.first.path, r"$['store']['bicycle']");
      expect(matches.last.value, json['store']['book'][2]);
      expect(matches.last.path, r"$['store']['book'][2]");
    });

    test('Missing filter', () {
      expect(
          () => JsonPath(r'$.store..[?discounted]').read(json),
          throwsA(predicate((e) =>
              e is FilterNotFound && e.toString().contains('discounted'))));
    });
  });
}
