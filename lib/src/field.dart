import 'package:jessie/src/json_path.dart';

class Field extends JsonPath {
  Field(this.name);

  final String name;

  @override
  Iterable call(Iterable nodes) => nodes
      .where((node) => node is Map && node.containsKey(name))
      .map((node) => node[name]);

  @override
  String toString() => "['$name']";
}
