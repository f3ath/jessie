import 'package:json_path/src/grammar/parser_ext.dart';
import 'package:json_path/src/grammar/select_all.dart';
import 'package:petitparser/petitparser.dart';

final wildcard = char('*').value(selectAll);
