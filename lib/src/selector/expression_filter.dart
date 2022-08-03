import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/wildcard.dart';

class ExpressionFilter extends Wildcard {
  ExpressionFilter(this.filter);

  final Predicate filter;

  @override
  Iterable<JsonPathMatch> apply(JsonPathMatch match) =>
      super.apply(match).where(filter);
}

typedef Extractor<T> = T Function(JsonPathMatch match);
typedef Predicate = Extractor<bool>;
