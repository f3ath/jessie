import 'package:json_path/src/selector/selector.dart';

Selector unionSelector(Iterable<Selector> selectors) =>
    (node) => selectors.expand((s) => s(node));
