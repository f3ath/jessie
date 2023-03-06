import 'package:json_path/src/expression/expression.dart';

class FunCall {
  FunCall(this.name, this.args);

  final String name;
  final List<Expression> args;

  @override
  String toString() => '$name($args)';
}
