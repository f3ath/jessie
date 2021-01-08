import 'package:json_path/json_pointer.dart';
import 'package:json_path/src/any_match.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/matching_context.dart';
import 'package:json_path/src/quote.dart';

/// Creates a match for the root element
JsonPathMatch rootMatch(
        dynamic value, String expression, Map<String, CallbackFilter> filter) =>
    _newMatch(
        value, r'$', const JsonPointer(), MatchingContext(expression, filter));

class ListMatch extends AnyMatch<List> {
  const ListMatch(
      List value, String path, JsonPointer pointer, MatchingContext context)
      : super(value, path, pointer, context);

  /// Creates a match for the child element.
  JsonPathMatch child(int key) => _newMatch(
      value[key],
      path + '[' + key.toString() + ']',
      pointer.append(key.toString()),
      context);
}

class MapMatch extends AnyMatch<Map> {
  const MapMatch(
      Map value, String path, JsonPointer pointer, MatchingContext context)
      : super(value, path, pointer, context);

  /// Creates a match for the child element.
  JsonPathMatch child(String key) => _newMatch(
      value[key], path + '[' + quote(key) + ']', pointer.append(key), context);
}

/// Creates a new match depending on the value type
JsonPathMatch _newMatch(
    dynamic value, String path, JsonPointer pointer, MatchingContext context) {
  if (value is List) return ListMatch(value, path, pointer, context);
  if (value is Map) return MapMatch(value, path, pointer, context);
  return AnyMatch(value, path, pointer, context);
}
