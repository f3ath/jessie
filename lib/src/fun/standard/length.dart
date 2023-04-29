import 'package:json_path/fun_sdk.dart';

/// The standard `length()` function.
/// See https://ietf-wg-jsonpath.github.io/draft-ietf-jsonpath-base/draft-ietf-jsonpath-base.html#name-length-function-extension
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
