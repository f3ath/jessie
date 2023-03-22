import 'package:json_path/fun_sdk.dart';

class IsObject implements Fun1<bool, Maybe> {
  @override
  final name = 'is_object';

  @override
  bool call(v) => v.map((v) => v is Map).or(false);
}
