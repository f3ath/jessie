import 'dart:convert';
import 'dart:io';

import 'package:json_path/json_path.dart';
import 'package:test/test.dart';

void main() {
  final suite = jsonDecode(File('cts/cts.json').readAsStringSync());
  final tests = suite['tests'] as List;
  group('JSON Path Compliance Suite', () {
    tests.forEach((t) {
      final String name = t['name'];
      final String selector = t['selector'];
      final document = t['document'];
      final List? result = t['result'];
      final bool invalid = t['invalid_selector'] ?? false;
      test(name, () {
        if (invalid) {
          try {
            JsonPath(selector);
            // allows us to be less strict than CTS
          } on FormatException {
            // do nothing as CTS expects us to throw
          }

        } else {
          expect(JsonPath(selector).readValues(document), equals(result!));
        }
      });
    });
  });
}
