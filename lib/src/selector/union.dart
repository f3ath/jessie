import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector.dart';

class Union implements Selector {
  const Union(this._elements);

  final Iterable<Selector> _elements;

  @override
  Iterable<JsonPathMatch> apply(JsonPathMatch match) =>
      _elements.map((e) => e.apply(match)).expand((_) => _);
}
