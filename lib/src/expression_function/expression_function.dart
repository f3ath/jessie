import 'package:json_path/json_path.dart';

abstract class ExpressionFunction {
  apply(JsonPathMatch match);
}
