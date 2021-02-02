import 'package:json_path/src/grammar/integer.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/selector/expression_filter.dart';
import 'package:petitparser/petitparser.dart';

Parser<Eval> _build() {
  final _true = string('true').trim().map<bool>((value) => true);
  final _false = string('false').trim().map<bool>((value) => false);

  final _literal =
      (_false | _true | integer | doubleQuotedString | singleQuotedString)
          .map<Eval>((value) => (match) => value);

  final _term = undefined();

  final _parens = (char('(').trim() & _term & char(')').trim())
      .map((value) => (match) => value[1](match));

  final _index = (char('[') &
          (integer | doubleQuotedString | singleQuotedString) &
          char(']'))
      .map((value) => value[1])
      .map<Eval>((value) => (match) {
            final key = value;
            final v = match.value;
            if (key is int && v is List && key < v.length && key >= 0) {
              return v[key];
            } else if (key is String && v is Map && v.containsKey(key)) {
              return v[key];
            }
          });

  final _dotName = (char('.') & dotString).map((value) => (match) {
        final key = value.last;
        final v = match.value;
        if (v is Map && v.containsKey(key)) {
          return v[key];
        }
      });

  final _nodeMapper = _index | _dotName;

  final _node = (char('@') & _nodeMapper).map<Eval>((value) => value.last);

  final _comparable = _parens | _literal | _node;

  final _comparison = (_comparable & string('==').trim() & _comparable)
      .map((value) => (match) => value.first(match) == value.last(match));

  _term.set(_comparison | _parens | _literal | _node);

  return (string('?(') & _term & char(')')).map((value) => value[1]);
}

final expression = _build();
