import 'package:json_path/json_path.dart';
import 'package:json_path/src/grammar/integer.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/selector/expression_filter.dart';
import 'package:petitparser/petitparser.dart';
import 'package:json_path/src/it.dart' as it;

Parser<Predicate> _build() {
  final trueLiteral = string('true').map(it.to(true));
  final falseLiteral = string('false').map(it.to(false));
  final nullLiteral = string('null').map(it.to(null));

  final literal = (falseLiteral |
          trueLiteral |
          nullLiteral |
          integer |
          doubleQuotedString |
          singleQuotedString)
      .map((value) => (match) => value);

  final index = (char('[') &
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

  final dotName = (char('.') & dotString).map(it.last).map((key) => (v) {
        if (v is Map && v.containsKey(key)) {
          return v[key];
        }
      });

  final nodeFilter = (index | dotName)
      .plus()
      .map(
          (value) => value.reduce((value, element) => (v) => element(value(v))))
      .map((value) => (match) => value(match.value));

  final currentObject = char('@').map((_) => (match) => match.value);

  final node =
      (currentObject & nodeFilter.optional()).map(it.lastWhere(it.isNotNull));

  final term = undefined();

  final parens = (char('(').trim() & term & char(')').trim()).map((_) => _[1]);

  final operand = parens | literal | node;

  final eq = string('==')
      .map<_BinaryOp>(it.to((algebra, left, right) => algebra.eq(left, right)));

  final ne = string('!=')
      .map<_BinaryOp>(it.to((algebra, left, tight) => algebra.ne(left, tight)));

  final ge = string('>=')
      .map<_BinaryOp>(it.to((algebra, left, right) => algebra.ge(left, right)));

  final gt = string('>')
      .map<_BinaryOp>(it.to((algebra, left, right) => algebra.gt(left, right)));

  final le = string('<=')
      .map<_BinaryOp>(it.to((algebra, left, right) => algebra.le(left, right)));

  final lt = string('<')
      .map<_BinaryOp>(it.to((algebra, left, right) => algebra.lt(left, right)));

  final or = string('||')
      .map<_BinaryOp>(it.to((algebra, left, right) => algebra.or(left, right)));

  final and = string('&&').map<_BinaryOp>(
      it.to((algebra, left, right) => algebra.and(left, right)));

  final binaryOperator = eq | ne | ge | gt | le | lt | or | and;

  final expression = (operand & binaryOperator.trim() & operand)
      .map((value) => (JsonPathMatch match) {
            final op = value[1];
            return op(
                match.context.algebra, value.first(match), value.last(match));
          });

  term.set(expression | operand);

  return (string('?(') & term & char(')')).map((_) => _[1]).map<Predicate>(
      (eval) => (match) => match.context.algebra.isTruthy(eval(match)));
}

typedef _BinaryOp = bool Function(Algebra algebra, dynamic left, dynamic right);

final expression = _build();
