import 'package:petitparser/petitparser.dart';

final integer =
    (char('-').optional() & digit().plus()).flatten().map(int.parse);

final float =
    (char('-').optional() & digit().star() & char('.') & digit().plus())
        .flatten()
        .map(double.parse);

final number = float | integer;