import 'dart:math';

import 'package:json_path/json_path.dart';

/// Selects zero or more nodes from the JSON [document].
typedef NodeSelector = Iterable<Node> Function(Node document);

NodeSelector arrayIndexSelector(int offset) => (node) sync* {
      final value = node.value;
      if (value is List) {
        final index = offset < 0 ? value.length + offset : offset;
        if (index >= 0 && index < value.length) {
          yield node.valueAt(index);
        }
      }
    };

NodeSelector arraySliceSelector({int? start, int? stop, int? step}) {
  step ??= 1;

  return (node) sync* {
    final value = node.value;
    if (value is List) {
      yield* _SliceIterator()
          .iterate(value, start, stop, step)
          .map(node.valueAt);
    }
  };
}

NodeSelector fieldSelector(String name) => (node) sync* {
      final value = node.value;
      if (value is Map && value.containsKey(name)) {
        yield node.child(name);
      }
    };

typedef _Filter = Iterable<Node> Function(Iterable<Node> nodes);

Iterable<Node> selectAll(Node node) sync* {
  final value = node.value;
  if (value is Map) {
    yield* value.entries.map((e) => node.child(e.key));
  }
  if (value is List) {
    yield* value.asMap().entries.map((e) => node.valueAt(e.key));
  }
}

NodeSelector unionSelector(Iterable<NodeSelector> selectors) =>
    (node) => selectors.expand((s) => s(node));

NodeSelector sequenceSelector(Iterable<NodeSelector> selectors) {
  final filter = selectors.fold<_Filter>((v) => v,
      (filter, selector) => (nodes) => filter(nodes).expand(selector));
  return (node) => filter([node]);
}

Iterable<Node> selectAllRecursively(Node node) sync* {
  yield node;
  yield* selectAll(node)
      .where((e) => e.value is Map || e.value is List)
      .map(selectAllRecursively)
      .expand((_) => _);
}

NodeSelector filterSelector(NodeMapper<bool> predicate) =>
    (node) => selectAll(node).where(predicate);

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
