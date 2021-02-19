import 'package:json_path/src/grammar/integer.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/selector/expression_filter.dart';
import 'package:petitparser/petitparser.dart';

Parser<Eval> _build() {
  final _true = string('true').map((_) => true);
  final _false = string('false').map((_) => false);
  final _null = string('null').map((_) => null);

  final _literal = (_false |
          _true |
          _null |
          integer |
          doubleQuotedString |
          singleQuotedString)
      .map<Eval>((value) => (match) => value);

  final _index = (char('[') &
          (integer | doubleQuotedString | singleQuotedString) &
          char(']'))
      .map((value) => value[1])
      .map((key) => (v) {
            if (key is int && v is List && key < v.length && key >= 0) {
              return v[key];
            } else if (key is String && v is Map && v.containsKey(key)) {
              return v[key];
            }
          });

  final _dotName = (char('.') & dotString).map((value) => (v) {
        final key = value.last;
        if (v is Map && v.containsKey(key)) {
          return v[key];
        }
      });

  final _nodeFilter = (_index | _dotName)
      .plus()
      .map(
          (value) => value.reduce((value, element) => (v) => element(value(v))))
      .map<Eval>((value) => (match) => value(match.value));

  final _node = (char('@') & _nodeFilter).map((value) => value.last);

  final _term = undefined();

  final _parens =
      (char('(').trim() & _term & char(')').trim()).map((value) => value[1]);

  final _comparable = _parens | _literal | _node;

  final _comparison = (_comparable & string('==').trim() & _comparable)
      .map((value) => (match) => value.first(match) == value.last(match));

  _term.set(_comparison | _comparable);

  return (string('?(') & _term & char(')')).map((value) => value[1]);
}

final expression = _build();
