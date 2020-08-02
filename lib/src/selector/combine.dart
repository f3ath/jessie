import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

/// A combination of two adjacent selectors
class Combine with SelectorMixin {
  Combine(this._left, this._right)
      : _realLeft = _left is Combine ? _left._realRight : _left,
        _realRight = _right is Combine ? _right._realRight : _right;

  @override
  Iterable<Result> filter(Iterable<Result> results) =>
      _right.filter(_left.filter(results));

  @override
  String expression([Selector previous]) =>
      _left.expression() + _right.expression(_realLeft);

  final Selector _left;
  final Selector _right;

  /// The rightmost _actual_ selector in the left subtree
  final Selector _realLeft;

  /// The rightmost _actual_ selector in the right subtree (and in the entire tree)
  final Selector _realRight;
}
