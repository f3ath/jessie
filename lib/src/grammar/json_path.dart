import 'package:json_path/src/grammar/selector.dart';
import 'package:json_path/src/selector.dart';
import 'package:json_path/src/selector/sequence.dart';
import 'package:petitparser/petitparser.dart';

final jsonPath = selector
    .star()
    .skip(before: char(r'$'))
    .end()
    .map((value) => Sequence(value.cast<Selector>()));
