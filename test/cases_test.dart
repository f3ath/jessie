import 'package:json_path/fun_extra.dart';
import 'package:json_path/json_path.dart';

import 'helper.dart';

void main() {
  runTestsInDirectory('cts');
  runTestsInDirectory('test/cases/standard');
  runTestsInDirectory('test/cases/non_standard',
      parser: JsonPathParser(userFunctions: [
        ReverseFun(),
        SiblingsFun(),
        XorFun(),
      ]));
}
