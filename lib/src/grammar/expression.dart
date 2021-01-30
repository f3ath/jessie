import 'package:json_path/src/grammar/common.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/selector/expression_filter.dart';
import 'package:petitparser/petitparser.dart';

Parser<Eval> _build() {
  final _true =
      string('true').trim().map<Eval<bool>>((value) => (match) => true);
  final _false =
      string('false').trim().map<Eval<bool>>((value) => (match) => false);
  final _integer = integer.map<Eval<int>>((value) => (match) => value);
  final _dString =
      doubleQuotedString.map<Eval<String>>((value) => (match) => value);
  final _sString =
      singleQuotedString.map<Eval<String>>((value) => (match) => value);

  final _literal = (_false | _true | _integer | _dString | _sString);

  final _term = undefined();

  final _parens = (char('(').trim() & _term & char(')').trim())
      .map((value) => (match) => value[1](match));

  final _index = (char('[') & _integer & char(']'))
      .map<Eval<int>>((value) => value[1])
      .map<Eval>((value) => (match) {
            final index = value(match);
            final v = match.value;
            if (v is List && index < v.length && index >= 0) {
              return v[index];
            }
          });

  final _nodeMapper = _index;

  final _node = (char('@') & _nodeMapper).map<Eval>((value) => value.last);

  final _comparable = _parens | _literal | _node;

  final _comparison = (_comparable & string('==').trim() & _comparable)
      .map((value) => (match) => value.first(match) == value.last(match));

  _term.set(_comparison | _parens | _literal | _node);

  return (string('?(') & _term & char(')')).map((value) => value[1]);
}

final expression = _build();
