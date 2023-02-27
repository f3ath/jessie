import 'package:petitparser/petitparser.dart';

final _funNameFirst = lowercase();
final _funNameChar = [char('_'), digit(), lowercase()].toChoiceParser();

final funName = (_funNameFirst & _funNameChar.star()).flatten();
