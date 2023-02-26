import 'package:json_path/src/grammar/number.dart';
import 'package:json_path/src/selector.dart';
import 'package:petitparser/petitparser.dart';

final _colon = char(':').trim();

final _maybeInteger = integer.optional();

final arraySlice = (_maybeInteger &
        _maybeInteger.skip(before: _colon) &
        _maybeInteger.skip(before: _colon).optional())
    .map((value) =>
        arraySliceSelector(start: value[0], stop: value[1], step: value[2]));
