import 'package:json_path/src/static_node_mapper.dart';
import 'package:petitparser/petitparser.dart';

extension ParserExt<R> on Parser<R> {
  /// Returns a predefined value parser.
  Parser<V> value<V>(V v) => map((_) => v);

  Parser<StaticNodeMapper<R>> toNodeMapper() => map(StaticNodeMapper.new);

  Parser<T> tryMap<T>(T Function(R r) mapper) => TryMapParser(this, mapper);
}

/// A parser that performs a transformation with a given function on the
/// successful parse result of the delegate.
class TryMapParser<T, R> extends DelegateParser<T, R> {
  TryMapParser(super.delegate, this.callback);

  /// The production action to be called.
  final R Function(T t) callback;

  @override
  Result<R> parseOn(Context context) {
    try {
      final result = delegate.parseOn(context);
      if (result.isSuccess) {
        return result.success(callback(result.value));
      } else {
        return result.failure(result.message);
      }
    } on Exception catch (e) {
      return context.failure(e.toString());
    }
  }

  @override
  bool hasEqualProperties(TryMapParser<T, R> other) =>
      super.hasEqualProperties(other) && callback == other.callback;

  @override
  TryMapParser<T, R> copy() => TryMapParser<T, R>(delegate, callback);
}
