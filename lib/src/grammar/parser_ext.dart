import 'package:petitparser/petitparser.dart';

extension ParserExt<R> on Parser<R> {
  /// Returns a predefined value parser.
  Parser<V> value<V>(V v) => map((_) => v);

  /// Makes a list of this elements separated by [separator] (a comma by default).
  Parser<List<R>> toList([Parser? separator]) => [
        map((v) => [v]),
        skip(before: (separator ?? char(',')).trim()).star()
      ].toSequenceParser().map<List<R>>((v) => v.expand<R>((e) => e).toList());

  /// Makes a list consisting of a single element.
  Parser<List<R>> toSingularList() => map((v) => [v]);

  /// Same in parenthesis.
  Parser<R> inParens() => skip(before: char('('), after: char(')'));

  /// Same in brackets.
  Parser<R> inBrackets() => skip(before: char('['), after: char(']'));

  Parser<T> tryMap<T>(T Function(R r) mapper) => TryMapParser(this, mapper);
}

extension ParserListStringExt on Parser<List<String>> {
  Parser<String> join([String separator = '']) => map((v) => v.join(separator));
}

class TryMapParser<T, R> extends MapParser<T, R> {
  TryMapParser(super.delegate, super.callback);

  @override
  Result<R> parseOn(Context context) {
    try {
      return super.parseOn(context);
    } on Exception catch (e) {
      return context.failure(e.toString());
    }
  }

  @override
  TryMapParser<T, R> copy() => TryMapParser<T, R>(delegate, callback);
}
