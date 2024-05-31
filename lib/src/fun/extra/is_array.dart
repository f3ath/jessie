import 'package:json_path/fun_sdk.dart';

/// Returns true if the value is a JSON array.
class IsArray implements Fun1<bool, Maybe> {
  const IsArray();

  @override
  final name = 'is_array';

  @override
  bool call(v) => v.map((v) => v is List).or(false);
}
