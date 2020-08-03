import 'package:json_path/src/ast.dart';
import 'package:json_path/src/parser_state.dart';
import 'package:json_path/src/selector/root.dart';
import 'package:json_path/src/selector/selector.dart';

class Parser {
  const Parser();

  /// Builds a selector from the JsonPath [expression]
  Selector parse(String expression) {
    if (expression.isEmpty) throw FormatException('Empty expression');
    ParserState state = Ready(Root());
    AST(_tokenize(expression)).children.forEach((node) {
      state = state.process(node);
    });
    return state.selector;
  }

  Iterable<String> _tokenize(String expr) =>
      _tokens.allMatches(expr).map((match) => match.group(0));

  static final _tokens = RegExp([
    r'\$', // root
    r'\[', // open bracket
    r'\]', // closing bracket
    r'\.\.', // recursion
    r'\.', // child
    r'\*', // wildcard
    r'\:', // slice
    r'\,', // union
    r"'(?:[^'\\]|\\.)*'", // quoted string
    r'-?\d+', // number
    r'[A-Za-z_-]+', // field
  ].join('|'));
}
