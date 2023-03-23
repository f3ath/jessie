import 'package:json_path/fun_sdk.dart';

/// The standard `length()` function.
class Length implements Fun1<Maybe, Maybe> {
  const Length();

  @override
  final name = 'length';

  @override
  Maybe call(Maybe value) => value
      .type<String>()
      .map((it) => it.length)
      .fallback(() => value.type<List>().map((it) => it.length))
      .fallback(() => value.type<Map>().map((it) => it.length));
}
