import 'package:json_path/json_path.dart';
import 'package:test/test.dart';

void main() {
  group('Algebra.strict', () {
    test('lt throws TypeError', () {
      expect(() => Algebra.strict.lt(1, '2'), throwsA(isA<TypeError>()));
    });
    test('le throws TypeError', () {
      expect(() => Algebra.strict.le(1, '2'), throwsA(isA<TypeError>()));
    });
    test('gt throws TypeError', () {
      expect(() => Algebra.strict.gt(1, '2'), throwsA(isA<TypeError>()));
    });
    test('ge throws TypeError', () {
      expect(() => Algebra.strict.ge(1, '2'), throwsA(isA<TypeError>()));
    });
    test('isTruthy throws TypeError', () {
      expect(() => Algebra.strict.isTruthy('foo'), throwsA(isA<TypeError>()));
    });
  });
}
