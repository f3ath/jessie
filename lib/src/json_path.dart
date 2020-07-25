abstract class JsonPath {
  /// Applies this JSONPath to the [nodes]
  Iterable call(Iterable nodes);

  /// The string expression without leading `$`
  @override
  String toString();

  /// A shortcut for `then()`
  JsonPath operator |(JsonPath other) => then(other);

  /// Combines this expression with the [other]
  JsonPath then(JsonPath other) => _Chain(this, other);

  /// Filters the given nodes.
  /// Returns an Iterable of all elements found
  Iterable filter(dynamic node) => call([node]);
}

class _Chain extends JsonPath {
  _Chain(this.first, this.second);

  final JsonPath first;

  final JsonPath second;

  @override
  Iterable call(Iterable nodes) => second(first(nodes));

  @override
  String toString() => '$first$second';
}
