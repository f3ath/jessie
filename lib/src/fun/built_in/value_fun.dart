import 'package:json_path/functions.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

class ValueFun implements Fun1<Maybe, Nodes> {
  const ValueFun();

  @override
  final name = 'value';

  @override
  Maybe apply(Nodes arg) => arg.asValue;
}
