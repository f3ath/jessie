import 'package:json_path/src/expression/expression.dart';
import 'package:petitparser/parser.dart';

Parser<Expression<bool>> negation(Parser<Expression<bool>> p) =>
    p.skip(before: char('!').trim()).map((expr) => expr.map((v) => !v));
