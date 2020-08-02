import 'package:json_path/src/selector/combine.dart';
import 'package:json_path/src/selector/selector.dart';

mixin SelectorMixin implements Selector {
  /// Combines this expression with the [other]
  @override
  Selector then(Selector other) => Combine(this, other);
}
