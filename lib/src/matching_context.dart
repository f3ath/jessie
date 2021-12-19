import 'package:json_path/src/algebra.dart';
import 'package:json_path/src/named_filter.dart';

class MatchingContext {
  const MatchingContext(this.filters, this.algebra);

  /// Named callback filters
  final Map<String, NamedFilter> filters;

  /// Rules to use for expressions evaluation.
  final Algebra algebra;
}
