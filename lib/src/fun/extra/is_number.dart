import 'package:json_path/fun_sdk.dart';

/// Checks if the value is a JSON number.
class IsNumber implements Fun1<bool, Maybe> {
  const IsNumber();

  @override
  final name = 'is_number';

  @override
  bool call(v) => v.map((v) => v is num).or(false);
}
