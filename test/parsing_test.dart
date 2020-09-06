import 'package:json_path/json_path.dart';
import 'package:test/test.dart';

void main() {
  test('FormatException is thrown', () {
    expect(() => JsonPath(r'$.foo[?]'), throwsFormatException);
    expect(() => JsonPath(r'$.foo]'), throwsFormatException);
  });
}
