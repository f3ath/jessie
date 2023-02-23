import 'package:json_path/src/match_set.dart';

/// An empty [MatchSet]. This is the implementation of the `Nothing` data type
/// from the JSONPath type system.
class Nothing implements MatchSet {
  @override
  final isEmpty = true;

  @override
  final isNotEmpty = false;

  @override
  final isSingular = false;

  @override
  final length = 0;

  @override
  get value => throw StateError('There is nothing');
}
