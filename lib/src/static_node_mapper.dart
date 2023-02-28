import 'package:json_path/src/node.dart';
import 'package:json_path/src/node_mapper.dart';

/// A substitute for NodeMapper where the value is known at parse time.
class StaticNodeMapper<T> implements NodeMapper<T> {
  StaticNodeMapper(this.value);

  final T value;

  @override
  T apply(Node node) => value;

  @override
  NodeMapper<R> map<R>(R Function(T v) mapper) =>
      StaticNodeMapper(mapper(value));

  @override
  NodeMapper<R> flatMap<R, M1>(
      NodeMapper<M1> m1, R Function(T v, M1 m1) mapper) {
    if (m1 is StaticNodeMapper<M1>) {
      return StaticNodeMapper(mapper(value, m1.value));
    }
    return NodeMapper((node) => mapper(value, m1.apply(node)));
  }
}
