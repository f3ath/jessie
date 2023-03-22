import 'package:json_path/fun_sdk.dart';

/// Checks if the value is a JSON object.
class IsObject implements Fun1<bool, Maybe> {
  const IsObject();

  @override
  final name = 'is_object';

  @override
  bool call(v) => v.map((v) => v is Map).or(false);
}
