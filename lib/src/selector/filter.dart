import 'package:json_path/json_path.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/predicate.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class Filter with SelectorMixin implements Selector {
  Filter(this.name, this.isApplicable);

  final String name;

  final Predicate isApplicable;

  @override
  Iterable<JsonPathMatch> read(Iterable<JsonPathMatch> matches) =>
      matches.where((r) => isApplicable(r.value));

  @override
  String expression() => '[?$name]';

  @override
  dynamic replace(dynamic json, Replacement replacement) =>
      isApplicable(json) ? replacement(json) : json;
}
