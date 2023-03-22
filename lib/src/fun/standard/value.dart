import 'package:json_path/fun_sdk.dart';

class Value implements Fun1<Maybe, Nodes> {
  const Value();

  @override
  final name = 'value';

  @override
  Maybe call(Nodes arg) => arg.asValue;
}
