import 'package:json_path/src/grammar/array_slice_selector.dart';
import 'package:json_path/src/grammar/number.dart';
import 'package:petitparser/petitparser.dart';

final _colon = char(':').trim();

final _optionalInt = integer.optional();

final arraySlice = (_optionalInt &
        _optionalInt.skip(before: _colon) &
        _optionalInt.skip(before: _colon).optional())
    .map((value) =>
        arraySliceSelector(start: value[0], stop: value[1], step: value[2]));
