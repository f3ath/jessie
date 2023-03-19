import 'package:json_path/fun_sdk.dart';

class XorFun implements Fun2<bool, bool, bool> {
  @override
  final name = 'xor';

  @override
  bool apply(bool first, bool second) => first ^ second;
}
