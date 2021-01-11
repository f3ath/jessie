import 'package:json_path/json_pointer.dart';
import 'package:json_path/src/path/any_match.dart';
import 'package:json_path/src/path/json_path_match.dart';
import 'package:json_path/src/path/matching_context.dart';
import 'package:json_path/src/path/quote.dart';

/// Creates a match for the root element
JsonPathMatch rootMatch(
        dynamic value, String expression, Map<String, CallbackFilter> filter) =>
    _newMatch(
        value: value,
        path: r'$',
        pointer: JsonPointer(),
        context: MatchingContext(expression, filter),
        parent: null);

class ListMatch extends AnyMatch<List> {
  const ListMatch(
      {required List value,
      required String path,
      required JsonPointer pointer,
      required MatchingContext context,
      JsonPathMatch? parent})
      : super(
            value: value,
            path: path,
            pointer: pointer,
            context: context,
            parent: parent);

  /// Creates a match for the child element.
  JsonPathMatch child(int key) => _newMatch(
      value: value[key],
      path: path + '[' + key.toString() + ']',
      pointer: pointer.append(key.toString()),
      context: context,
      parent: this);
}

class MapMatch extends AnyMatch<Map> {
  const MapMatch(
      {required Map value,
      required String path,
      required JsonPointer pointer,
      required MatchingContext context,
      JsonPathMatch? parent})
      : super(
            value: value,
            path: path,
            pointer: pointer,
            context: context,
            parent: parent);

  /// Creates a match for the child element.
  JsonPathMatch child(String key) => _newMatch(
      value: value[key],
      path: path + '[' + quote(key) + ']',
      pointer: pointer.append(key),
      context: context,
      parent: this);
}

/// Creates a new match depending on the value type
JsonPathMatch _newMatch(
    {required dynamic value,
    required String path,
    required JsonPointer pointer,
    required MatchingContext context,
    required JsonPathMatch? parent}) {
  if (value is List) {
    return ListMatch(
        value: value,
        path: path,
        pointer: pointer,
        context: context,
        parent: parent);
  }
  if (value is Map) {
    return MapMatch(
        value: value,
        path: path,
        pointer: pointer,
        context: context,
        parent: parent);
  }
  return AnyMatch(
      value: value,
      path: path,
      pointer: pointer,
      context: context,
      parent: parent);
}
