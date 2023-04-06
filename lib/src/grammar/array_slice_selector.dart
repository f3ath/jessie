import 'package:json_path/src/selector.dart';

Selector arraySliceSelector({int? start, int? stop, int? step}) =>
    (node) sync* {
      final slice = node.slice(start: start, stop: stop, step: step);
      if (slice != null) yield* slice;
    };
