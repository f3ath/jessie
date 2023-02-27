import 'package:json_path/src/parser/strings.dart';
import 'package:json_path/src/parser/wildcard.dart';
import 'package:petitparser/petitparser.dart';

final dotName =
    [memberNameShorthand, wildcard].toChoiceParser().skip(before: char('.'));
