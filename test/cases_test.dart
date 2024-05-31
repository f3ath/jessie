import 'package:json_path/fun_extra.dart';
import 'package:json_path/json_path.dart';

import 'helper.dart';

void main() {
  runTestsInDirectory('test/cases/cts');
  runTestsInDirectory('test/cases/standard');
  runTestsInDirectory('test/cases/extra',
      parser: JsonPathParser(functions: [
        const Index(),
        const IsArray(),
        const IsBoolean(),
        const IsNumber(),
        const IsObject(),
        const IsString(),
        const Key(),
        const Reverse(),
        const Siblings(),
        const Xor(),
      ]));
}
