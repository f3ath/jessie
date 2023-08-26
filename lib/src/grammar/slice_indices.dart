import 'dart:math';

Iterable<int> sliceIndices(int length, int? start, int? stop, int step) sync* {
  if (step > 0) yield* _forward(length, start ?? 0, stop ?? length, step);
  if (step < 0) yield* _backward(length, start, stop, step);
}

Iterable<int> _forward(int length, int start, int stop, int step) sync* {
  final low = start < 0 ? max(length + start, 0) : start;
  final high = stop < 0 ? length + stop : min(length, stop);
  for (var i = low; i < high; i += step) {
    yield i;
  }
}

Iterable<int> _backward(int length, int? start, int? stop, int step) sync* {
  final low = _low(stop, length);
  final high = _high(start, length);
  for (var i = high; i > low; i += step) {
    yield i;
  }
}

/// exclusive
int _low(int? stop, int length) => switch (stop) {
      null => -1,
      < 0 => max(length + stop, -1),
      _ => stop,
    };

/// inclusive
int _high(int? start, int length) => switch (start) {
      null => length - 1,
      < 0 => length + start,
      _ => min(start, length - 1),
    };
