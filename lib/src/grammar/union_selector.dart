import 'package:json_path/src/grammar/selector.dart';

Selector unionSelector(Iterable<Selector> selectors) =>
    (node) => selectors.expand((s) => s(node));
