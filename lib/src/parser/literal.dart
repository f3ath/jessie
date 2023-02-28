import 'package:json_path/src/fun/types/value.dart';
import 'package:json_path/src/node_mapper.dart';
import 'package:json_path/src/parser/number.dart';
import 'package:json_path/src/parser/parser_ext.dart';
import 'package:json_path/src/parser/strings.dart';
import 'package:petitparser/parser.dart';

final Parser<NodeMapper<Value>> literal = [
  string('null').map((_) => null),
  string('false').map((_) => false),
  string('true').map((_) => true),
  number,
  quotedString,
].toChoiceParser().map(Value.new).toNodeMapper();
