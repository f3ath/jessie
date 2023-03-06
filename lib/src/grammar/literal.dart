import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/expression/static_expression.dart';
import 'package:json_path/src/grammar/number.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:petitparser/parser.dart';

final Parser<Expression<Maybe>> literal = [
  string('null').map((_) => null),
  string('false').map((_) => false),
  string('true').map((_) => true),
  number,
  quotedString,
].toChoiceParser().map(Just.new).map(StaticExpression.new);
