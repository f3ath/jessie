import 'package:json_path/src/grammar/json_path.dart';
import 'package:petitparser/reflection.dart';
import 'package:test/test.dart';

void main() {
  final parser = JsonPathGrammarDefinition([]).build();

  group('Parser', () {
    test('Linter is happy', () {
      expect(linter(parser), isEmpty);
    });
    group('Valid expressions', () {
      for (final expr in [
        r'$.foo.bar',
        r'$.foo.*',
        r'$[0]',
        r'$[:]',
        r'$[ ::]',
        r'$[ 1:]',
        r'$[1 : :]',
        r'$[:42]',
        r'$[2 :42 :]',
        r'$[:2 :42]',
        r'$[ :   :3]',
        r'$[1: -5:  -2]',
        r'$["foo 12 [] ? *bar привет"]',
        r"$['foo 12 [] ? *bar привет']",
        r'$[ 0, 2, -1 ]',
        r'$.foo[*, -4, 3,:4, :, "foo" ]',
        r'$..[0]',
        r'$..*',
        r'$.store.book[*].author',
        r'$..author',
        r'$.store.*',
        r'$.store..price',
        r'$..book[2]',
        r'$..book[-1]',
        r'$..book[0,1]',
        r'$..book[:2]',
        r'$.☺',
        r'$[?@ > count($)]',
        r'$[?@ > count($.bar)]',
        r'$[?@.foo > $.bar]',
        r'$[?(@.a == @.b)]',
      ]) {
        test(expr, () {
          final result = parser.parse(expr);
          if (result.isFailure) {
            fail(
                '${result.message}, buffer: "${result.buffer}", pos: ${result.position}');
          }
        });
      }
    });
    group('Invalid expressions', () {
      for (final expr in [
        r"$(key,more)",
        r"$.",
        r"$.[key]",
        r"$['foo'bar']",
        r"$['two'.'some']",
        r"$[two.some]",
        r'$$',
        r'$....',
        r'$...foo',
        r'$["""]',
        r'$["\"]',
        r'$["\z"]',
        r'$["]',
        r'$["foo"bar"]',
        r'$[1 1]',
        r'$[1+2]',
        r'$[1874509822062987436598726432519879857164397163046130756769274369]',
        r'$[:::]',
        r'$[]',
        r'',
        r'.foo',
      ]) {
        test(expr, () {
          try {
            expect(parser.parse(expr).isFailure, isTrue);
          } on FormatException catch (_) {}
        });
      }
    });
  });
}
