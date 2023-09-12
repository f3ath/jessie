import 'package:petitparser/petitparser.dart';

final _digit1 = range('1', '9');

final _integer = (char('0') | (char('-').optional() & _digit1 & digit().star()))
    .flatten('an integer number expected');

final _float =
    (char('-').optional() & digit().star() & char('.') & digit().plus())
        .flatten('a floating point number expected');

final _exp = ((_float | _integer | string('-0')) &
        char('e') &
        anyOf('-+').optional() &
        digit().plus())
    .flatten('an exponent number expected');

final integer = _integer.map(int.parse);

final Parser<num> number = [
  _exp.map(double.parse),
  _float.map(double.parse),
  string('-0').map((_) => 0),
  integer,
].toChoiceParser();
