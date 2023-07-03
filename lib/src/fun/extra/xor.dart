import 'package:json_path/fun_sdk.dart';

class Xor implements Fun2<bool, bool, bool> {
  const Xor();

  @override
  final name = 'xor';

  @override
  bool call(bool first, bool second) => first ^ second;
}
