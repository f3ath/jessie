import 'package:json_path/src/node_mapper.dart';

class FunCall {
  FunCall(this.name, this.args);

  final String name;
  final List<NodeMapper> args;

  @override
  String toString() => name;
}
