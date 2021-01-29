import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector.dart';

class Union implements Selector {
  const Union(this._elements);

  final Iterable<Selector> _elements;

  @override
  Iterable<JsonPathMatch> read(JsonPathMatch match) =>
      _elements.map((e) => e.read(match)).expand((_) => _);
}
