import 'package:json_path/json_path.dart';

abstract class ExpressionFunction<T> {
  T apply(Node node);
}
