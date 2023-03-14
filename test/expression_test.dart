import 'package:json_path/functions.dart';
import 'package:json_path/src/expression/static_expression.dart';
import 'package:json_path/src/node/root_node.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Expression', () {
    group('Static', () {
      final node = RootNode('foo');
      final s = StaticExpression('bar');
      final d = Expression((n) => n.value);
      test('map()', () {
        expect(s.map((v) => '$v!').apply(node), 'bar!');
      });
      test('merge() with non-static', () {
        expect(s.merge(d, (v, m) => v + m).apply(node), 'barfoo');
      });
    });
  });
}
