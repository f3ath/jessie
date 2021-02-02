import 'package:json_path/src/grammar/selector.dart' show selector;
import 'package:json_path/src/selector.dart';
import 'package:json_path/src/selector/sequence.dart';
import 'package:petitparser/petitparser.dart';

final jsonPath = (char(r'$') & selector.star())
    .end()
    .map((value) => Sequence((value.last as List).map((e) => e as Selector)));
