import 'package:json_path/src/selector/selector.dart';

SelectorFun unionSelector(Iterable<SelectorFun> selectors) =>
    (node) => selectors.expand((s) => s(node));
