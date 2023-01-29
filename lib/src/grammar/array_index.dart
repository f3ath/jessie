import 'package:json_path/src/grammar/number.dart';
import 'package:json_path/src/selector/array_index.dart';
import 'package:petitparser/petitparser.dart';

final arrayIndex = integer.map(ArrayIndex.new);
