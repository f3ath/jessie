import 'package:petitparser/petitparser.dart';

final minus = char('-');

final integer = (minus.optional() & digit().plus()).flatten().map(int.parse);
