import 'dart:convert';
import 'dart:io';

import 'package:json_path/json_path.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void runTestsInDirectory(String dirName, {JsonPathParser? parser}) {
  JsonPath jsonPath(String expression) =>
      parser?.parse(expression) ?? JsonPath(expression);

  Directory(dirName)
      .listSync()
      .whereType<File>()
      .where((file) =>
          file.path.endsWith('.json') && !file.path.endsWith('.schema.json'))
      .forEach((file) {
    group(path.basename(file.path), () {
      final cases = jsonDecode(file.readAsStringSync());
      for (final Map t in cases['tests'] as List) {
        for (final key in t.keys) {
          if (!_knownKeys.contains(key)) {
            throw ArgumentError('Unknown key "$key"');
          }
        }

        final String selector = t['selector'];

        final document = t['document'];
        final String? name = t['name'];
        final List? paths = t['paths'];
        final List? pointers = t['pointers'];
        final String? skip = t['skip'];
        final List? values = t['result'];
        final bool? invalid = t['invalid_selector'];
        group(name ?? selector, () {
          if (values is List) {
            test('values', () {
              expect(jsonPath(selector).readValues(document), equals(values));
            });
          }
          if (paths is List) {
            test('paths', () {
              final actual =
                  jsonPath(selector).read(document).map((e) => e.path).toList();
              expect(actual, equals(paths));
            });
          }
          if (pointers is List) {
            test('pointers', () {
              expect(
                jsonPath(selector)
                    .read(document)
                    .map((e) => e.pointer.toString())
                    .toList(),
                equals(pointers),
              );
            });
          }
          if (invalid == true) {
            test('invalid', () {
              expect(
                () => jsonPath(selector),
                throwsFormatException,
              );
            });
          }
          if ([values, paths, pointers, invalid].every((v) => v == null)) {
            throw ArgumentError('No expectations found');
          }
        }, skip: skip);
      }
    });
  });
}

const _knownKeys = {
  'document',
  'name',
  'paths',
  'pointers',
  'selector',
  'skip',
  'result',
  'invalid_selector',
};
