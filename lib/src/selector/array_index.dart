import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/match_factory.dart';
import 'package:json_path/src/selector/selector.dart';

class ArrayIndex implements Selector {
  ArrayIndex(this.index);

  final int index;

  @override
  Iterable<JsonPathMatch> read(JsonPathMatch match) sync* {
    if (match is ListMatch) {
      final normalizedIndex = index < 0 ? match.value.length + index : index;
      if (normalizedIndex >= 0 && normalizedIndex < match.value.length) {
        yield match.child(normalizedIndex);
      }
    }
  }
}
