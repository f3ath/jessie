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
      .where(
        (file) =>
            file.path.endsWith('.json') && !file.path.endsWith('.schema.json'),
      )
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
            final List? resultPaths = t['result_paths'];
            final List? resultsPaths = t['results_paths'];
            final List? pointers = t['result_pointers'];
            final String? skip = t['skip'];
            final List? result = t['result'];
            final List? results = t['results'];
            final bool? invalid = t['invalid_selector'];
            group(name ?? selector, () {
              if (result is List) {
                test(
                  'values',
                  () => expect(
                    jsonPath(selector).readValues(document),
                    equals(result),
                  ),
                );
              }
              if (results is List) {
                test(
                  'any of values',
                  () => expect(
                    jsonPath(selector).readValues(document),
                    anyOf(results),
                  ),
                );
              }
              if (resultPaths is List) {
                test(
                  'result_paths',
                  () => expect(
                    jsonPath(
                      selector,
                    ).read(document).map((e) => e.path).toList(),
                    equals(resultPaths),
                  ),
                );
              }
              if (resultsPaths is List) {
                test(
                  'results_paths',
                  () => expect(
                    jsonPath(
                      selector,
                    ).read(document).map((e) => e.path).toList(),
                    anyOf(resultsPaths),
                  ),
                );
              }
              if (pointers is List) {
                test(
                  'result_pointers',
                  () => expect(
                    jsonPath(
                      selector,
                    ).read(document).map((e) => e.pointer.toString()).toList(),
                    equals(pointers),
                  ),
                );
              }
              if (invalid == true) {
                test(
                  'invalid',
                  () => expect(() => jsonPath(selector), throwsFormatException),
                );
              }
              if ((result ?? results ?? resultPaths ?? pointers ?? invalid) ==
                  null) {
                throw ArgumentError('No expectations found');
              }
            }, skip: skip);
          }
        });
      });
}

const _knownKeys = {
  'document',
  'invalid_selector',
  'name',
  'result_paths',
  'results_paths',
  'result_pointers',
  'result',
  'results',
  'selector',
  'skip',
  'tags',
};
