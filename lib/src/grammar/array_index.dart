import 'package:json_path/src/grammar/array_index_selector.dart';
import 'package:json_path/src/grammar/number.dart';
import 'package:petitparser/petitparser.dart';

final arrayIndex = integer.map(arrayIndexSelector);
