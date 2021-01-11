/// Thrown when the referenced value is not found in the document.
class InvalidRoute implements Exception {
  const InvalidRoute(this.pointer);

  final String pointer;

  @override
  String toString() => 'No value is referenced by $pointer';
}
