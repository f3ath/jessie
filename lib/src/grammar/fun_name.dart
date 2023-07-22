import 'package:petitparser/petitparser.dart';

final _funNameFirst = lowercase();
final _funNameChar = [char('_'), digit(), lowercase()].toChoiceParser();

/// Function name.
final funName =
    (_funNameFirst & _funNameChar.star()).flatten('a function name expected');
