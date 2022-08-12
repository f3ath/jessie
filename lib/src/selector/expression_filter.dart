import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/match_predicate.dart';
import 'package:json_path/src/selector/wildcard.dart';

class ExpressionFilter extends Wildcard {
  ExpressionFilter(this.filter);

  final MatchPredicate filter;

  @override
  Iterable<JsonPathMatch> apply(JsonPathMatch match) =>
      super.apply(match).where((match) {
        try {
          return filter(match);
        } catch (e) {
          return match.context.algebra.onException(e);
        }
      });
}
