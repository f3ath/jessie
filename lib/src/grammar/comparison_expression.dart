import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/grammar/compare.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:petitparser/parser.dart';

Parser<Expression<bool>> comparisonExpression(Parser<Expression<Maybe>> val) =>
    (val & cmpOperator & val).map((v) {
      final [
        Expression<Maybe> left,
        String op,
        Expression<Maybe> right,
      ] = v;
      return left.merge(right, (l, r) => compare(op, l, r));
    });
