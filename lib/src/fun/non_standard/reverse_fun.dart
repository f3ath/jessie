import 'package:json_path/fun_sdk.dart';

/// Reverses the string.
class ReverseFun implements Fun1<Maybe, Maybe> {
  @override
  final name = 'reverse';

  @override
  Maybe call(Maybe v) =>
      v.type<String>().map((s) => s.split('').reversed.join());
}
