import 'package:json_path/src/path/grammar.dart';
import 'package:json_path/src/path/selector/selector.dart';
import 'package:petitparser/core.dart';

Parser<Selector> buildParser() {
  return jsonPath;
}
