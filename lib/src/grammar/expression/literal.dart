import 'package:json_path/src/grammar/number.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:petitparser/parser.dart';

final Parser literal = [
  string('null').map((_) => null),
  string('false').map((_) => false),
  string('true').map((_) => true),
  number,
  quotedString,
].toChoiceParser();
