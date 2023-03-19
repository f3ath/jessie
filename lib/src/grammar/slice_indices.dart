import 'dart:math';

Iterable<int> sliceIndices(int length, int? start, int? stop, int step) sync* {
  if (step > 0) {
    yield* _forward(length, start ?? 0, stop ?? length, step);
  }
  if (step < 0) {
    yield* _backward(length, start, stop, step);
  }
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
