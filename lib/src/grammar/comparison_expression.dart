import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/grammar/cmp_operator.dart';
import 'package:json_path/src/grammar/compare.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:petitparser/parser.dart';

Parser<Expression<bool>> comparisonExpression(Parser<Expression<Maybe>> val) =>
    (val & cmpOperator & val).map((v) {
      final Expression<Maybe> left = v[0];
      final String op = v[1];
      final Expression<Maybe> right = v[2];

      return left.merge(right, (l, r) => compare(op, l, r));
    });
