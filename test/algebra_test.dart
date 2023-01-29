import 'package:json_path/json_path.dart';
import 'package:test/test.dart';

void main() {
  group('Algebra', () {
    final algebra = Algebra.strict;

    test(" 1 < '2' is false", () {
      expect(algebra.lt(1, '2'), isFalse);
    });
    test(" 1 <= '2' is false", () {
      expect(algebra.le(1, '2'), isFalse);
    });
    test(" 1 > '2' is false", () {
      expect(algebra.gt(1, '2'), isFalse);
    });
    test(" 1 >= '2' is false", () {
      expect(algebra.ge(1, '2'), isFalse);
    });
    test('[] == []', () {
      expect(algebra.eq([], []), isTrue);
    });
    test('[1, 2] != [2, 1]', () {
      expect(algebra.eq([1, 2], [2, 1]), isFalse);
    });
    test("{'a': 1, 'b': 2} == {'b': 2, 'a': 1}", () {
      expect(algebra.eq({'a': 1, 'b': 2}, {'b': 2, 'a': 1}), isTrue);
    });
  });
}
