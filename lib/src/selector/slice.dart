import 'dart:math';

import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class Slice with SelectorMixin {
  Slice({int first, this.last, int step})
      : first = first ?? 0,
        step = step ?? 1;

  final int first;

  final int last;

  final int step;

  @override
  Iterable<Result> filter(Iterable<Result> results) => results.map((r) {
        if (step > 0 && r.value is List) {
          return _filterList(r.value, r.path);
        }
        return const <Result>[];
      }).expand((_) => _);

  @override
  String expression([Selector previous]) =>
      '[${first == 0 ? '' : first}:${last ?? ''}${step != 1 ? ':$step' : ''}]';

  Iterable<Result> _filterList(List list, String path) =>
      _for(_actualFirst(list.length), _actualLast(list.length), step)
          .map((i) => Result(list[i], path + '[$i]'));

  int _actualFirst(int len) => max(0, first < 0 ? (len + first) : first);

  int _actualLast(int len) {
    if (last == null) return len;
    if (last < 0) return min(len, len + last);
    return min(len, last);
  }

  Iterable<int> _for(int from, int to, int step) sync* {
    for (var i = from; i < to; i += step) {
      yield i;
    }
  }
}
