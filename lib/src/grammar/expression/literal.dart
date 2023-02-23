import 'package:json_path/src/grammar/number.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/match_mapper.dart';
import 'package:json_path/src/parser_ext.dart';
import 'package:petitparser/parser.dart';

final _nullLiteral = string('null').value(null).toMatchMapper();
final _falseLiteral = string('false').value(false).toMatchMapper();
final _trueLiteral = string('true').value(true).toMatchMapper();

final boolLiteral = [
  _falseLiteral,
  _trueLiteral,
].toChoiceParser().cast<MatchMapper>();

final Parser<MatchMapper> literal = [
  _nullLiteral,
  boolLiteral,
  number.toMatchMapper(),
  quotedString.toMatchMapper(),
].toChoiceParser();
