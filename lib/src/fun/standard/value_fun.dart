import 'package:json_path/fun_sdk.dart';

class ValueFun implements Fun1<Maybe, Nodes> {
  const ValueFun();

  @override
  final name = 'value';

  @override
  Maybe call(Nodes arg) => arg.asValue;
}
