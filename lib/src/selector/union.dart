import 'package:json_path/src/id.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/selector.dart';

class Union implements Selector {
  Union(Iterable<Selector> elements) : elements = [...elements];

  final List<Selector> elements;

  @override
  Iterable<JsonPathMatch> read(JsonPathMatch match) =>
      elements.map((e) => e.read(match)).expand(id);
}
