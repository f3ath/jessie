import 'package:json_path/src/id.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/selector.dart';

typedef Filter = Iterable<JsonPathMatch> Function(
    Iterable<JsonPathMatch> matches);

class Sequence implements Selector {
  Sequence(Iterable<Selector> selectors)
      : _filter = selectors.fold<Filter>(
            id,
            (filter, selector) =>
                (matches) => filter(matches).map(selector.read).expand(id));

  final Filter _filter;

  @override
  Iterable<JsonPathMatch> read(JsonPathMatch match) => _filter([match]);
}
