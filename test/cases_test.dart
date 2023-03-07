import 'dart:convert';
import 'dart:io';

import 'package:json_path/json_path.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  const allowedFields = {
    'document',
    'name',
    'paths',
    'pointers',
    'selector',
    'skip',
    'values',
  };
  Directory('test/cases')
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.json'))
      .forEach((file) {
    group(path.basenameWithoutExtension(file.path), () {
      final cases = jsonDecode(file.readAsStringSync());
      for (final Map t in cases['tests'] as List) {
        for (final key in t.keys) {
          if (!allowedFields.contains(key)) {
            throw 'Invalid key "$key"';
          }
        }

        final document = t['document'];
        final name = t['name'];
        final paths = t['paths'];
        final pointers = t['pointers'];
        final selector = t['selector'];
        final skip = t['skip'];
        final values = t['values'];
        group(name ?? selector, () {
          if (values is List) {
            test('values', () {
              final actual = JsonPath(selector).readValues(document);
              expect(actual, equals(values));
            });
          }
          if (paths is List) {
            test('paths', () {
              final actual =
                  JsonPath(selector).read(document).map((e) => e.path).toList();
              expect(actual, equals(paths));
            });
          }
          if (pointers is List) {
            test('pointers', () {
              expect(
                JsonPath(selector)
                    .read(document)
                    .map((e) => e.pointer.toString())
                    .toList(),
                equals(pointers),
              );
            });
          }
          if ([values, paths, pointers].every((_) => _ == null)) {
            throw 'No expectations found';
          }
        }, skip: skip);
      }
    });
  });
}
