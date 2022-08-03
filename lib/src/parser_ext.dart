import 'package:json_path/src/selector/expression_filter.dart';
import 'package:petitparser/petitparser.dart';

extension ParserExt<R> on Parser<R> {
  /// Returns a predefined value parser.
  Parser<V> asLiteral<V>(V v) => map((_) => v);

  Parser<Extractor> asExtractor() => map<Extractor>(_same);
}

Extractor<V> _same<V>(V v) => (_) => v;
