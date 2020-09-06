import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/object_wildcard.dart';
import 'package:json_path/src/selector/recursive.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

/// A combination of two adjacent selectors
class Joint with SelectorMixin implements Selector {
  Joint(this.left, this.right);

  /// Rightmost leaf in the tree
  static Selector rightmost(Selector s) => s is Joint ? rightmost(s.right) : s;

  /// Leftmost leaf in the tree
  static Selector leftmost(Selector s) => s is Joint ? leftmost(s.left) : s;

  static String delimiter(Selector left, Selector right) =>
      (left is! Recursive && right is ObjectWildcard) ? '.' : '';

  /// Left subtree
  final Selector left;

  /// Right subtree
  final Selector right;

  @override
  Iterable<JsonPathMatch> read(Iterable<JsonPathMatch> matches) =>
      right.read(left.read(matches));

  @override
  String expression() =>
      left.expression() +
      delimiter(rightmost(left), leftmost(right)) +
      right.expression();

  @override
  dynamic replace(dynamic json, Replacement replacement) =>
      left.replace(json, (_) => right.replace(_, replacement));
}
