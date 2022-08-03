import 'package:json_path/src/json_path_match.dart';
import 'package:petitparser/petitparser.dart';

extension ParserExt<R> on Parser<R> {
  /// Returns a predefined value parser.
  Parser<V> value<V>(V v) => map((_) => v);

  Parser<MatchMapper<R>> toMatchMapper() =>
      map<MatchMapper<R>>((R r) => (_) => r);
}

typedef MatchMapper<T> = T Function(JsonPathMatch match);
