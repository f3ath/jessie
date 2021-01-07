/// Iterates over maps and lists
Iterable<MapEntry> iterate(dynamic v) sync* {
  if (v is Map) {
    yield* v.entries;
  }
  if (v is List) {
    yield* v.asMap().entries;
  }
}
