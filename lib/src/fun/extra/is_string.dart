import 'package:json_path/fun_sdk.dart';

/// Checks if the value is a JSON string.
class IsString implements Fun1<bool, Maybe> {
  const IsString();

  @override
  final name = 'is_string';

  @override
  bool call(v) => v.map((v) => v is String).or(false);
}
