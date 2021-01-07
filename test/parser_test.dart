import 'package:json_path/src/build_parser.dart';
import 'package:test/test.dart';

void main() {
  group('Parser', () {
    group('Valid expressions', () {
      [
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
      ].forEach((expr) {
        test(expr, () {
          final parser = buildParser().parse(expr);
          if (parser.isFailure) {
            fail(parser.message);
          }
        });
      });
    });
    group('Invalid expressions', () {
      [
        r'',
        r'$$',
        r'.foo',
        r'$....',
        r'$...foo',
        r'$[1+2]',
        r'$[1874509822062987436598726432519879857164397163046130756769274369]',
        r'$["""]',
        r'$["]',
        r'$[1 1]',
        r'$[]',
        r'$["\"]',
        r'$["\z"]',
        r'$[:::]',
        r'$["foo"bar"]',
        r"$['foo'bar']",
      ].forEach((expr) {
        test(expr, () {
          try {
            expect(buildParser().parse(expr).isFailure, isTrue);
          } on FormatException catch (_) {}
        });
      });
    });
  });
}
