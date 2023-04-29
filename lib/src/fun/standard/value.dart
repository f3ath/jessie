import 'package:json_path/fun_sdk.dart';

/// The standard `value()` function.
/// See https://ietf-wg-jsonpath.github.io/draft-ietf-jsonpath-base/draft-ietf-jsonpath-base.html#name-value-function-extension
class Value implements Fun1<Maybe, Nodes> {
  const Value();

  @override
  final name = 'value';

  @override
  Maybe call(Nodes arg) => arg.asValue;
}
