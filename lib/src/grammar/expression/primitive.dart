import 'package:json_path/src/grammar/number.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/match_mapper.dart';
import 'package:json_path/src/parser_ext.dart';
import 'package:petitparser/parser.dart';

final _nullPrimitive = string('null').value(null).toMatchMapper();
final _falsePrimitive = string('false').value(false).toMatchMapper();
final _truePrimitive = string('true').value(true).toMatchMapper();

final boolPrimitive = [
  _falsePrimitive,
  _truePrimitive,
].toChoiceParser().cast<MatchMapper>();

final primitive = [
  _nullPrimitive,
  boolPrimitive,
  number.toMatchMapper(),
  quotedString.toMatchMapper(),
].toChoiceParser();
