import 'package:json_path/src/grammar/selector.dart';
import 'package:json_path/src/grammar/slice_iterator.dart';
import 'package:json_path/src/node/node_ext.dart';

Selector arraySliceSelector({int? start, int? stop, int? step}) =>
    (node) sync* {
      final value = node.value;
      if (value is List) {
        yield* SliceIterator()
            .iterate(value, start, stop, step ?? 1)
            .map(node.valueAt);
      }
    };
