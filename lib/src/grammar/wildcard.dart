import 'package:json_path/src/grammar/all_children.dart';
import 'package:json_path/src/grammar/parser_ext.dart';
import 'package:petitparser/petitparser.dart';

final wildcard = char('*').value(allChildren);
