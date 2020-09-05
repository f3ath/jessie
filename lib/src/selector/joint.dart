import 'package:json_path/src/result.dart';
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
  Iterable<Result> filter(Iterable<Result> results) =>
      right.filter(left.filter(results));

  @override
  String expression() =>
      left.expression() +
      delimiter(rightmost(left), leftmost(right)) +
      right.expression();

  @override
  dynamic apply(dynamic json, Function(dynamic _) mutate) =>
      left.apply(json, (_) => right.apply(_, mutate));
}
