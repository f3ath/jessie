import 'package:json_path/fun_sdk.dart';

/// Checks if the value is a JSON boolean.
class IsBoolean implements Fun1<bool, Maybe> {
  const IsBoolean();

  @override
  final name = 'is_boolean';

  @override
  bool call(v) => v.map((v) => v is bool).or(false);
}
