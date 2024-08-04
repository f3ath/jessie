import 'package:petitparser/petitparser.dart';

const _intMin = -9007199254740991;
const _intMax = 9007199254740991;

final _digit1 = range('1', '9');

final _integer = (char('0') | (char('-').optional() & _digit1 & digit().star()))
    .flatten('integer expected');

final _float =
    (char('-').optional() & digit().plus() & char('.') & digit().plus())
        .flatten('floating point expected');

final _exp = ((_float | _integer | string('-0')) &
        charIgnoringCase('e') &
        anyOf('-+').optional() &
        digit().plus())
    .flatten('an exponent number expected');

final integer =
    _integer.map(int.parse).where((it) => it >= _intMin && it <= _intMax);

final Parser<num> number = [
  _exp.map(double.parse),
  _float.map(double.parse),
  string('-0').map((_) => 0),
  integer,
].toChoiceParser();
