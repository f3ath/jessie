import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/fun/fun_factory.dart';
import 'package:json_path/src/fun/standard/count.dart';
import 'package:json_path/src/fun/standard/length.dart';
import 'package:json_path/src/fun/standard/match.dart';
import 'package:json_path/src/fun/standard/search.dart';
import 'package:json_path/src/fun/standard/value.dart';
import 'package:json_path/src/grammar/json_path.dart';
import 'package:json_path/src/grammar/parser_ext.dart';
import 'package:petitparser/parser.dart';
import 'package:petitparser/reflection.dart';
import 'package:test/test.dart';

void main() {
  final parser = JsonPathGrammarDefinition(
    FunFactory(<Fun>[
      const Length(),
      const Count(),
      const Match(),
      const Search(),
      const Value(),
    ]),
  ).build();

  group('Parser', () {
    test('Linter is happy', () {
      expect(linter(parser), isEmpty);
    });
    test('Can use copy() after tryMap()', () {
      expect(char('x').tryMap((x) => x + x).copy(), isA<Parser<String>>());
    });
  });
}
