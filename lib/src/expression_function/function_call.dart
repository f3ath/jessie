class FunctionCall {
  FunctionCall(this.name, this.args);

  final String name;
  final List args;

  @override
  String toString() => name;
}
