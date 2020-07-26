import 'package:jessie/src/filter.dart';
import 'package:jessie/src/match.dart';

class Field extends Filter {
  Field(this.name);

  final String name;

  @override
  Iterable<PathMatch> call(Iterable<PathMatch> matches) => matches
      .where((m) => m.value is Map && m.value.containsKey(name))
      .map((m) => PathMatch(m.value[name], m.path + toString()));

  @override
  String toString() => "['$name']";
}
