import 'dart:math';

import 'package:json_path/src/child_match.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector.dart';

class ArraySlice implements Selector {
  ArraySlice({this.start, this.stop, int? step}) : step = step ?? 1;

  final int? start;
  final int? stop;
  final int step;

  @override
  Iterable<JsonPathMatch> apply(JsonPathMatch match) sync* {
    final value = match.value;
    if (value is List) {
      yield* _SliceIterator()
          .iterate(value, start, stop, step)
          .map((i) => ChildMatch.index(i, match));
    }
  }
}

class _SliceIterator {
  Iterable<int> iterate(List list, int? start, int? stop, int? step) sync* {
    step ??= 1;
    if (step > 0) {
      yield* _iterateForward(list, start ?? 0, stop ?? list.length, step);
    }
    if (step < 0) {
      yield* _iterateBackward(list, start, stop, step);
    }
  }

  Iterable<int> _iterateForward(
      List list, int start, int stop, int step) sync* {
    final low = start < 0 ? max(list.length + start, 0) : start;
    final high = stop < 0 ? list.length + stop : min(list.length, stop);
    for (var i = low; i < high; i += step) {
      yield i;
    }
  }

  Iterable<int> _iterateBackward(
      List list, int? start, int? stop, int step) sync* {
    final low = _low(stop, list.length);
    final high = _high(start, list.length);
    for (var i = high; i > low; i += step) {
      yield i;
    }
  }

  /// exclusive
  int _low(int? stop, int length) {
    if (stop == null) return -1;
    if (stop < 0) return max(length + stop, -1);
    return stop;
  }

  /// inclusive
  int _high(int? start, int length) {
    if (start == null) return length - 1;
    if (start < 0) return length + start;
    return min(start, length - 1);
  }
}
