import 'package:json_path/src/grammar/number.dart';
import 'package:json_path/src/selectors.dart';
import 'package:petitparser/petitparser.dart';

final arrayIndex = integer.map(arrayIndexSelector);
