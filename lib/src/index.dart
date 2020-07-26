import 'package:jessie/src/filter.dart';
import 'package:jessie/src/match.dart';

class Index extends Filter {
  Index(this.index);

  final int index;

  @override
  Iterable<PathMatch> call(Iterable<PathMatch> matches) => matches
      .where((m) => m.value is List && m.value.length > index + 1)
      .map((m) => PathMatch(m.value[index], m.path + toString()));

  @override
  String toString() => '[$index]';
}
