import 'package:json_path/src/node.dart';

class NodeMapper<T> {
  NodeMapper(this._map);

  final T Function(Node) _map;

  T applyTo(Node node) => _map(node);

  /// Creates a new [NodeMapper] by applying the [mapper] function
  /// to the value produced by this mapper.
  NodeMapper<R> map<R>(R Function(T v) mapper) =>
      NodeMapper((node) => mapper(applyTo(node)));

  /// Creates a new [NodeMapper] from the [other] [NodeMapper] and the
  /// [mapper] function. The [mapper] function is applied to the values
  /// produced by this an the [other] [NodeMapper].
  NodeMapper<R> flatMap<R, M>(
          NodeMapper<M> other, R Function(T self, M other) mapper) =>
      NodeMapper((node) => mapper(applyTo(node), other.applyTo(node)));
}
