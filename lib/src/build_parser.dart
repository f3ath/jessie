import 'package:json_path/src/grammar.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:petitparser/core.dart';

Parser<Selector> buildParser() {
  return jsonPath;
}
