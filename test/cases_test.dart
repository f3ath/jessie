import 'dart:convert';
import 'dart:io';

import 'package:json_path/json_path.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  const allowedFields = {
    'name',
    'selector',
    'document',
    'values',
    'paths',
    'pointers'
  };
  Directory('test/cases')
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.json'))
      .forEach((file) {
    group(path.basenameWithoutExtension(file.path), () {
      final cases = jsonDecode(file.readAsStringSync());
      (cases['tests'] as List).forEach((t) {
        (t as Map).keys.forEach((key) {
          if (!allowedFields.contains(key)) {
            throw 'Invalid key "$key"';
          }
        });

        final name = t['name'];
        final values = t['values'];
        final paths = t['paths'];
        final pointers = t['pointers'];
        final jp = JsonPath(t['selector']);
        group(name, () {
          if (values is List) {
            test('values', () {
              expect(jp.readValues(t['document']), equals(values));
            });
          }
          if (paths is List) {
            test('paths', () {
              expect(jp.read(t['document']).map((e) => e.path).toList(),
                  equals(paths));
            });
          }
          if (pointers is List) {
            test('pointers', () {
              expect(
                  jp
                      .read(t['document'])
                      .map((e) => e.pointer.toString())
                      .toList(),
                  equals(pointers));
            });
          }
          if ([values, paths, pointers].every((_) => _ == null)) {
            throw 'No expectations found';
          }
        });
      });
    });
  });
}
