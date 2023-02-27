import 'package:json_path/src/fun/type_system.dart';
import 'package:json_path/src/node.dart';
import 'package:json_path/src/parser/types.dart';

abstract class Resolvable {
  factory Resolvable(dynamic val) =>
      val is NodeMapper ? _Dynamic(val) : _Static(val);

  resolve(Node node);
}

class _Static implements Resolvable {
  _Static(this._value);

  final dynamic _value;

  @override
  resolve(Node node) => _value;
}

class _Dynamic implements Resolvable {
  _Dynamic(this._mapper);

  final NodeMapper _mapper;

  @override
  resolve(Node node) => _valOf(_mapper(node));

  _valOf(x) {
    if (x is NodesType) {
      if (x.length == 1) return x.single.value;
      return const Nothing();
    }
    return x;
  }
}
