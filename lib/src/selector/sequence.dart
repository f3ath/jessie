import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector.dart';

typedef Filter = Iterable<JsonPathMatch> Function(
    Iterable<JsonPathMatch> matches);

class Sequence implements Selector {
  Sequence(Iterable<Selector> selectors)
      : _filter = selectors.fold<Filter>(
            (_) => _,
            (filter, selector) => (matches) =>
                filter(matches).map(selector.apply).expand((_) => _));

  final Filter _filter;

  @override
  Iterable<JsonPathMatch> apply(JsonPathMatch match) => _filter([match]);
}
