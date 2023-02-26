import 'package:json_path/src/grammar/number.dart';
import 'package:json_path/src/selector.dart';
import 'package:petitparser/petitparser.dart';

final arrayIndex = integer.map(arrayIndexSelector);
