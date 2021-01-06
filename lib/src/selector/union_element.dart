import 'package:json_path/src/json_path_match.dart';

abstract class UnionElement {
  Iterable<JsonPathMatch> read(JsonPathMatch match);
}
