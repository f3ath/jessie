import 'package:jessie/src/filter.dart';

class Field extends Filter {
  Field(this.name);

  final String name;

  @override
  Iterable call(Iterable nodes) => nodes
      .where((node) => node is Map && node.containsKey(name))
      .map((node) => node[name]);

  @override
  String toString() => "['$name']";
}
