import 'package:json_path/src/parser_ext.dart';
import 'package:json_path/src/selector/wildcard.dart';
import 'package:petitparser/petitparser.dart';

final wildcard = char('*').value(const Wildcard());
