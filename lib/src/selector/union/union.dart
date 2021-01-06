import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/union/union_element.dart';

class Union implements Selector {
  Union(Iterable<UnionElement> elements) : elements = [...elements];

  final List<UnionElement> elements;

  @override
  Iterable<JsonPathMatch> read(Iterable<JsonPathMatch> matches) => matches
      .map((m) => elements.map((e) => e.read(m)))
      .expand((_) => _)
      .expand((_) => _);
}
