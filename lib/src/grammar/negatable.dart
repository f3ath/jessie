import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/grammar/negation.dart';
import 'package:petitparser/petitparser.dart';

Parser<Expression<bool>> negatable(Parser<Expression<bool>> p) =>
    [negation(p), p].toChoiceParser();
