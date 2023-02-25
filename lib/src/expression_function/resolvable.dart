import 'package:json_path/src/node.dart';
import 'package:json_path/src/node_mapper.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

abstract class Resolvable {
  factory Resolvable(dynamic val) =>
      val is NodeMapper ? _Dynamic(val) : _Static(val);

  // final dynamic _val;

  resolve(Node match); // => _resolveMapper(_val, match);

// _resolveMapper(v, JsonPathMatch match) => (v is MatchMapper) ? v(match) : v;
}

class _Static implements Resolvable {
  _Static(this._value);

  final dynamic _value;

  @override
  resolve(Node match) => _value;
}

class _Dynamic implements Resolvable {
  _Dynamic(this._mapper);

  final NodeMapper _mapper;

  @override
  resolve(Node match) => _valOf(_mapper(match));

  _valOf(x) {
    if (x is Iterable<Node>) {
      if (x.length == 1) return x.single.value;
      return Nothing();
    }
    return x;
  }
}
