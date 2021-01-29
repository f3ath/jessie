import 'package:json_path/src/child_match.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector.dart';

class ArrayIndex implements Selector {
  ArrayIndex(this.index);

  final int index;

  @override
  Iterable<JsonPathMatch> apply(JsonPathMatch match) sync* {
    final value = match.value;
    if (value is List) {
      final normalized = index < 0 ? value.length + index : index;
      if (normalized >= 0 && normalized < value.length) {
        yield ChildMatch.index(normalized, match);
      }
    }
  }
}
