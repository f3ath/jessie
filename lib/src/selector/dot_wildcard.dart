import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/single_quote.dart';
import 'package:json_path/src/selector/wildcard.dart';

class DotWildcard implements Selector {
  const DotWildcard({this.wildcard = const Wildcard(quote: singleQuote)});

  final Wildcard wildcard;

  @override
  Iterable<JsonPathMatch> read(Iterable<JsonPathMatch> matches) =>
      matches.map(wildcard.read).expand((_) => _);
}
