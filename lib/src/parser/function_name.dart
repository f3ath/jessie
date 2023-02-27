import 'package:petitparser/petitparser.dart';

final _functionNameFirst = lowercase();
final _functionNameChar = [
  char('_'),
  digit(),
  lowercase(),
].toChoiceParser();

final functionName = (_functionNameFirst & _functionNameChar.star()).flatten();
