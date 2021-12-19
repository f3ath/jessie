import 'package:json_path/json_path.dart';
import 'package:json_path/src/grammar/integer.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/selector/expression_filter.dart';
import 'package:petitparser/petitparser.dart';
import 'package:json_path/src/it.dart' as it;

Parser<Predicate> _build() {
  final _true = string('true').map(it.to(true));
  final _false = string('false').map(it.to(false));
  final _null = string('null').map(it.to(null));

  final _literal = (_false |
          _true |
          _null |
          integer |
          doubleQuotedString |
          singleQuotedString)
      .map((value) => (match) => value);

  final _index = (char('[') &
          (integer | doubleQuotedString | singleQuotedString) &
          char(']'))
      .map((_) => _[1])
      .map((key) => (v) {
            if (key is int && v is List && key < v.length && key >= 0) {
              return v[key];
            } else if (key is String && v is Map && v.containsKey(key)) {
              return v[key];
            }
          });

  final _dotName = (char('.') & dotString).map(it.last).map((key) => (v) {
        if (v is Map && v.containsKey(key)) {
          return v[key];
        }
      });

  final _nodeFilter = (_index | _dotName)
      .plus()
      .map(
          (value) => value.reduce((value, element) => (v) => element(value(v))))
      .map((value) => (match) => value(match.value));

  final _currentObject = char('@').map((_) => (match) => match.value);

  final _node =
      (_currentObject & _nodeFilter.optional()).map(it.lastWhere(it.isNotNull));

  final _term = undefined();

  final _parens =
      (char('(').trim() & _term & char(')').trim()).map((_) => _[1]);

  final _operand = _parens | _literal | _node;

  final _eq = string('==')
      .map<_BinaryOp>(it.to((algebra, left, right) => algebra.eq(left, right)));

  final _ne = string('!=')
      .map<_BinaryOp>(it.to((algebra, left, tight) => algebra.ne(left, tight)));

  final _ge = string('>=')
      .map<_BinaryOp>(it.to((algebra, left, right) => algebra.ge(left, right)));

  final _gt = string('>')
      .map<_BinaryOp>(it.to((algebra, left, right) => algebra.gt(left, right)));

  final _le = string('<=')
      .map<_BinaryOp>(it.to((algebra, left, right) => algebra.le(left, right)));

  final _lt = string('<')
      .map<_BinaryOp>(it.to((algebra, left, right) => algebra.lt(left, right)));

  final _or = string('||')
      .map<_BinaryOp>(it.to((algebra, left, right) => algebra.or(left, right)));

  final _and = string('&&').map<_BinaryOp>(
      it.to((algebra, left, right) => algebra.and(left, right)));

  final _binaryOperator = _eq | _ne | _ge | _gt | _le | _lt | _or | _and;

  final _expression = (_operand & _binaryOperator.trim() & _operand)
      .map((value) => (JsonPathMatch match) {
            final op = value[1];
            return op(
                match.context.algebra, value.first(match), value.last(match));
          });

  _term.set(_expression | _operand);

  return (string('?(') & _term & char(')')).map((_) => _[1]).map<Predicate>(
      (eval) => (match) => match.context.algebra.isTruthy(eval(match)));
}

typedef _BinaryOp = bool Function(Algebra algebra, dynamic left, dynamic right);

final expression = _build();
