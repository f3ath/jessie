import 'package:json_path/fun_sdk.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Expression', () {
    group('Static', () {
      final node = Node('foo');
      final s = StaticExpression('bar');
      final d = Expression((n) => n.value);
      test('map()', () {
        expect(s.map((v) => '$v!').call(node), 'bar!');
      });
      test('merge() with non-static', () {
        expect(s.merge(d, (v, m) => v + m).call(node), 'barfoo');
      });
    });
  });
}
