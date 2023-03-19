import 'package:json_path/json_path.dart';
import 'package:test/test.dart';

void main() {
  group('JSONPath', () {
    test('toString()', () {
      final expr = r'$.foo.bar';
      expect('${JsonPath(expr)}', equals(expr));
    });
  });
}
