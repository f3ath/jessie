import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/grammar/wildcard.dart';
import 'package:petitparser/petitparser.dart';

final dotName =
    [memberNameShorthand, wildcard].toChoiceParser().skip(before: char('.'));
