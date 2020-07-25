abstract class Filter {
  const Filter();

  /// Applies this JSONPath to the [nodes]
  Iterable call(Iterable nodes);

  /// The string expression without leading `$`
  @override
  String toString();

  /// A shortcut for `then()`
  Filter operator |(Filter other) => then(other);

  /// Combines this expression with the [other]
  Filter then(Filter other) => _Chain(this, other);
}

class _Chain extends Filter {
  _Chain(this.first, this.second);

  final Filter first;

  final Filter second;

  @override
  Iterable call(Iterable nodes) => second(first(nodes));

  @override
  String toString() => '$first$second';
}
