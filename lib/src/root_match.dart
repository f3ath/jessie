import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/matching_context.dart';
import 'package:rfc_6901/rfc_6901.dart';

/// Creates a match for the root element
class RootMatch implements JsonPathMatch {
  RootMatch(this.value, Map<String, CallbackFilter> filters)
      : context = MatchingContext(filters);

  @override
  final MatchingContext context;

  @override
  final parent = null;

  @override
  final path = r'$';

  @override
  final pointer = JsonPointer();

  @override
  final value;
}
