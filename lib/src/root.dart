import 'package:jessie/src/filter.dart';
import 'package:jessie/src/match.dart';

class Root extends Filter {
  const Root();

  @override
  Iterable<PathMatch> call(Iterable<PathMatch> matches) =>
      matches.map((m) => PathMatch(m.value, toString()));

  @override
  String toString() => r'$';
}
