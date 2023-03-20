import 'package:json_path/src/grammar/parser_ext.dart';
import 'package:json_path/src/node.dart';
import 'package:petitparser/petitparser.dart';

final wildcard = char('*').value((Node node) => node.children);
