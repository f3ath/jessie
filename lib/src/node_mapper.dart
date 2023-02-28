import 'package:json_path/src/node.dart';

class NodeMapper<T> {
  NodeMapper(this._map);

  final T Function(Node) _map;

  T apply(Node node) => _map(node);

  /// Monadic mapper.
  NodeMapper<R> map<R>(R Function(T v) mapper) =>
      NodeMapper((node) => mapper(apply(node)));

  /// Monadic mapper.
  NodeMapper<R> flatMap<R, O1>(
          NodeMapper<O1> other, R Function(T self, O1 other) mapper) =>
      NodeMapper((node) => mapper(apply(node), other.apply(node)));
}
