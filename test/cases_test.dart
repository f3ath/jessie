import 'package:json_path/fun_extra.dart';
import 'package:json_path/json_path.dart';

import 'helper.dart';

void main() {
  runTestsInDirectory('test/cases/cts');
  runTestsInDirectory('test/cases/standard');
  runTestsInDirectory('test/cases/extra',
      parser: JsonPathParser(functions: const [
        Index(),
        IsArray(),
        IsBoolean(),
        IsNumber(),
        IsObject(),
        IsString(),
        Key(),
        Reverse(),
        Siblings(),
        Xor(),
      ]));
}
