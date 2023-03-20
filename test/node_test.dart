import 'package:json_path/src/node.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Node', () {
    test('equality', () {
      expect({Node(42), Node(42)}.length, equals(1));
    });
    test('toString()', () {
      expect('${Node(42)}', equals('Node(42)'));
    });
  });
}
