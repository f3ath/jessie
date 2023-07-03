import 'package:json_path/json_path.dart';
import 'package:test/test.dart';

void main() {
  group('JSONPath', () {
    test('toString()', () {
      const expr = r'$.foo.bar';
      expect('${JsonPath(expr)}', equals(expr));
    });
  });
  group('Invalid expressions', () {
    for (final expr in [
      [r"$(key,more)"],
      [r"$."],
      [r"$.[key]"],
      [r"$['foo'bar']"],
      [r"$['two'.'some']"],
      [r"$[two.some]"],
      [r'$$'],
      [r'$....'],
      [r'$...foo'],
      [r'$["""]'],
      [r'$["\"]'],
      [r'$["\z"]'],
      [r'$["]'],
      [r'$["foo"bar"]'],
      [r'$[1 1]'],
      [r'$[1+2]'],
      [r'$[1874509822062987436598726432519879857164397163046130756769274369]'],
      [r'$[:::]'],
      [r'$[]'],
      [r''],
      [r'.foo'],
    ]) {
      test(expr, () {
        try {
          JsonPath(expr[0]);
          fail('Expected FormatException');
        } on FormatException catch (e) {
          expect(e.message, isNotEmpty);
        }
      });
    }
  });
}
