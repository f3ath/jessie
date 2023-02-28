import 'package:json_path/src/fun/types/nothing.dart';

class Value<T> {
  Value(this._value);

  final T _value;

  Value<R> tryMap<R>(R Function(T value) mapper) {
    try {
      return map(mapper);
    } on Exception {
      return Nothing();
    }
  }

  Value<R> map<R>(R Function(T value) mapper) => Value(mapper(_value));

  Value<R> flatMap<R, V>(Value<V> other, R Function(T value, V other) mapper) =>
      other.map((other) => mapper(_value, other));

  T orElse(T Function() getter) => _value;

  Value<R> whereType<R>() {
    if (_value is R) return Value(_value as R);
    return Nothing();
  }

  final hasValue = true;

  final isNothing = false;
}
