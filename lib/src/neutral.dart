import 'package:jessie/jessie.dart';

class Neutral extends Filter {
  const Neutral();

  @override
  Iterable call(Iterable nodes) => nodes;

  @override
  String toString() => r'$';
}
