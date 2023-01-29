import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/parser_ext.dart';
import 'package:json_path/src/selector/field.dart';
import 'package:json_path/src/selector/wildcard.dart';
import 'package:petitparser/petitparser.dart';

final _wildcard = char('*').value(const Wildcard());
final _fieldName = unquotedString.map(Field.new);
final dotMatcher = (_fieldName | _wildcard).skip(before: char('.'));
