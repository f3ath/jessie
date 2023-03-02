import 'package:json_path/src/node_mapper.dart';
import 'package:json_path/src/parser/number.dart';
import 'package:json_path/src/parser/parser_ext.dart';
import 'package:json_path/src/parser/strings.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:petitparser/parser.dart';

final Parser<NodeMapper<Maybe>> literal = [
  string('null').map((_) => null),
  string('false').map((_) => false),
  string('true').map((_) => true),
  number,
  quotedString,
].toChoiceParser().map(Just.new).toNodeMapper();
