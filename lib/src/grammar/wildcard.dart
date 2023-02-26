import 'package:json_path/src/parser_ext.dart';
import 'package:json_path/src/selector.dart';
import 'package:petitparser/petitparser.dart';

final wildcard = char('*').value(selectAll);
