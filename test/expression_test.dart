import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/expression/static_expression.dart';
import 'package:json_path/src/node.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Expression', () {
    group('Static', () {
      final node = Node('foo');
      final s = StaticExpression(const Just('bar'));
      final d = Expression((Node n) => Just(n.value));
      test('map()', () {
        expect(s.map((v) => v.map((v) => '$v!').or('oops')).call(node), 'bar!');
      });
      test('merge() with non-static', () {
        expect(
          s
              .merge(d, (v, m) => v.merge(m, (a, b) => '$a$b').or('oops'))
              .call(node),
          'barfoo',
        );
      });
    });
  });
}
