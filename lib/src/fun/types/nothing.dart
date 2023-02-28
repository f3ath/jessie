import 'package:json_path/src/fun/types/value.dart';

class Nothing<T> implements Value<T> {
  const Nothing();

  @override
  final hasValue = false;

  @override
  final isNothing = true;

  @override
  Value<R> tryMap<R>(R Function(T value) mapper) => Nothing();

  @override
  Value<R> map<R>(R Function(T value) mapper) => Nothing();

  @override
  Value<R> flatMap<R, V>(Value<V> other, R Function(T value, V other) mapper) =>
      Nothing();

  @override
  T orElse(T Function() getter) => getter();

  @override
  Value<R> whereType<R>() => Nothing();
}
