import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/wildcard.dart';

class CallbackFilter extends Wildcard {
  const CallbackFilter(this.name);

  final String name;

  @override
  Iterable<JsonPathMatch> apply(JsonPathMatch match) =>
      super.apply(match).where(match.context.getFilter(name));
}
