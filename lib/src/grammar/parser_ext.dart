import 'package:json_path/src/expression/static_expression.dart';
import 'package:petitparser/petitparser.dart';

extension ParserExt<R> on Parser<R> {
  /// Returns a predefined value parser.
  Parser<V> value<V>(V v) => map((_) => v);

  Parser<StaticExpression<R>> toNodeMapper() => map(StaticExpression.new);

  Parser<T> tryMap<T>(T Function(R r) mapper) => TryMapParser(this, mapper);
}

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
