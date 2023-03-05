import 'package:json_path/json_path.dart';
import 'package:test/test.dart';

void main() {
  group('JSONPath', () {
    test('toString()', () {
      final jsonPath = JsonPath(r'$.foo.bar');
      expect('$jsonPath', r'JsonPath($.foo.bar)');
    });
  });
}
