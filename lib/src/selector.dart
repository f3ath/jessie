import 'package:json_path/json_path.dart';

abstract class Selector {
  /// Applies the selector to the [node]
  Iterable<Node> apply(Node node);
}
