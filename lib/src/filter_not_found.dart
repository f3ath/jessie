class FilterNotFound implements Exception {
  FilterNotFound(this.message);

  final String message;

  @override
  String toString() => message;
}
