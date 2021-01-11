import 'package:json_path/src/path/json_path_match.dart';
import 'package:json_path/src/path/selector/selector.dart';

typedef Filter = Iterable<JsonPathMatch> Function(
    Iterable<JsonPathMatch> matches);

class Sequence implements Selector {
  Sequence(Iterable<Selector> selectors)
      : _filter = selectors.fold<Filter>(
            (_) => _,
            (filter, selector) => (matches) =>
                filter(matches).map(selector.read).expand((_) => _));

  final Filter _filter;

  @override
  Iterable<JsonPathMatch> read(JsonPathMatch match) => _filter([match]);
}
