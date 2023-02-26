import 'package:json_path/src/node_mapper.dart';
import 'package:petitparser/petitparser.dart';

extension ParserExt<R> on Parser<R> {
  /// Returns a predefined value parser.
  Parser<V> value<V>(V v) => map((_) => v);

  Parser<NodeMapper<R>> toNodeMapper() =>
      map<NodeMapper<R>>((R r) => (_) => r);
}
