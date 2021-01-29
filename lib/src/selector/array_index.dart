import 'package:json_path/src/child_match.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector.dart';

class ArrayIndex implements Selector {
  ArrayIndex(this.index);

  final int index;

  @override
  Iterable<JsonPathMatch> read(JsonPathMatch match) sync* {
    final value = match.value;
    if (match is List) {
      final normalized = _normalize(value.length);
      if (normalized >= 0 && normalized < value.length) {
        yield ChildMatch.index(normalized, match);
      }
    }
  }

  int _normalize(int length) => index < 0 ? length + index : index;
}
