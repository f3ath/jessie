import 'package:petitparser/petitparser.dart';

final integer =
    (char('-').optional() & digit().plus()).flatten().map(int.parse);
