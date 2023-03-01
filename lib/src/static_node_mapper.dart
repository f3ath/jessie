import 'package:json_path/src/node.dart';
import 'package:json_path/src/node_mapper.dart';

/// A substitute for NodeMapper where the value is known at parse time.
class StaticNodeMapper<T> implements NodeMapper<T> {
  StaticNodeMapper(this.value);

  final T value;

  @override
  T applyTo(Node node) => value;

  @override
  NodeMapper<R> map<R>(R Function(T v) mapper) =>
      StaticNodeMapper(mapper(value));

  @override
  NodeMapper<R> flatMap<R, M>(NodeMapper<M> m, R Function(T v, M m) mapper) {
    if (m is StaticNodeMapper<M>) {
      return StaticNodeMapper(mapper(value, m.value));
    }
    return NodeMapper((node) => mapper(value, m.applyTo(node)));
  }
}
