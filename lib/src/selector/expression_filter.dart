import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/wildcard.dart';

class ExpressionFilter extends Wildcard {
  ExpressionFilter(this.eval);

  final Eval eval;

  @override
  Iterable<JsonPathMatch> apply(JsonPathMatch match) =>
      super.apply(match).where((match) {
        final val = eval(match);
        return (val == true ||
            (val is num && val != 0) ||
            (val is String && val.isNotEmpty));
      });
}

typedef Eval<T> = T Function(JsonPathMatch match);
