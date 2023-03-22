import 'package:json_path/fun_extra.dart';
import 'package:json_path/json_path.dart';
import 'package:json_path/src/fun/extra/is_array.dart';
import 'package:json_path/src/fun/extra/is_boolean.dart';
import 'package:json_path/src/fun/extra/is_number.dart';
import 'package:json_path/src/fun/extra/is_string.dart';

import 'helper.dart';

void main() {
  runTestsInDirectory('cts');
  runTestsInDirectory('test/cases/standard');
  runTestsInDirectory('test/cases/extra',
      parser: JsonPathParser(functions: [
        Reverse(),
        Siblings(),
        Xor(),
        IsObject(),
        IsString(),
        IsBoolean(),
        IsNumber(),
        IsArray()
      ]));
}
