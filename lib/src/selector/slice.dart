import 'dart:math';

import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class Slice with SelectorMixin implements Selector {
  Slice({int first, this.last, int step})
      : first = first ?? 0,
        step = step ?? 1;

  static Iterable<int> _for(int from, int to, int step) sync* {
    if (step < 1) return;
    for (var i = from; i < to; i += step) {
      yield i;
    }
  }

  final int first;

  final int last;

  final int step;

  @override
  Iterable<JsonPathMatch> read(Iterable<JsonPathMatch> matches) => matches
      .map((r) =>
          (r.value is List) ? _filterList(r.value, r.path) : <JsonPathMatch>[])
      .expand((_) => _);

  @override
  String expression() =>
      '[${first == 0 ? '' : first}:${last ?? ''}${step != 1 ? ':$step' : ''}]';

  @override
  dynamic replace(dynamic json, Replacement replacement) {
    if (json is List) {
      final indices = _indices(json);
      if (indices.isNotEmpty) {
        final copy = [...json];
        indices.forEach((i) {
          copy[i] = replacement(json[i]);
        });
        return copy;
      }
    }
    return json;
  }

  Iterable<JsonPathMatch> _filterList(List list, String path) =>
      _indices(list).map((i) => JsonPathMatch(list[i], path + '[$i]'));

  Iterable<int> _indices(List list) =>
      _for(_actualFirst(list.length), _actualLast(list.length), step);

  int _actualFirst(int len) => max(0, first < 0 ? (len + first) : first);

  int _actualLast(int len) {
    if (last == null) return len;
    if (last < 0) return min(len, len + last);
    return min(len, last);
  }
}
