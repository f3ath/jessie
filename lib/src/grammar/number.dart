import 'package:petitparser/petitparser.dart';

final _digit1 = range('1', '9');

final integer = (char('0') | (char('-').optional() & _digit1 & digit().star()))
    .flatten()
    .map(int.parse);

final float =
    (char('-').optional() & digit().star() & char('.') & digit().plus())
        .flatten()
        .map(double.parse);

final Parser<num> number = [float, integer].toChoiceParser();
