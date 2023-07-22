import 'package:json_path/fun_sdk.dart';

/// Reverses the string.
class Reverse implements Fun1<Maybe, Maybe> {
  const Reverse();

  @override
  final name = 'reverse';

  @override
  Maybe call(Maybe v) =>
      v.type<String>().map((s) => s.split('').reversed.join());
}
