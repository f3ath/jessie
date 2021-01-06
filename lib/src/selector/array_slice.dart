import 'dart:math';

import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/selector.dart';

class ArraySlice implements Selector {
  ArraySlice({int? start, this.stop, int? step})
      : start = start ?? 0,
        step = step ?? 1;

  final int start;
  final int? stop;
  final int step;

  @override
  Iterable<JsonPathMatch> read(JsonPathMatch match) {
    final v = match.value;
    if (v is List) {
      return iterate(v).map((i) => JsonPathMatch(
          v[i], match.path + '[$i]', match.pointer.append(i.toString())));
    }
    return const <JsonPathMatch>[];
  }

  Iterable<int> iterate(List list) sync* {
    if (step == 0) return;
    final stop = this.stop ?? list.length;
    if (step > 0) {
      final low = start < 0 ? max(0, list.length + start) : start;
      final high = stop < 0 ? list.length + stop : min(list.length, stop);
      for (var i = low + (low % step); i < high; i += step) {
        yield i;
      }
    } else {
      final low = stop < 0 ? max(0, list.length + stop) : stop;
      final high =
          start < 0 ? list.length + start : min(list.length - 1, start);
      for (var i = high - (high % step); i > low; i += step) {
        yield i;
      }
    }
  }
}
