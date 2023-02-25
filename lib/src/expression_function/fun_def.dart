import 'package:json_path/src/expression_function/arg_validator.dart';

class FunDef {
  FunDef(Iterable<ArgValidator> args) : _expected = args.toList();
  final List<ArgValidator> _expected;

  /// Validates the [args] and returns a list of errors.
  /// Validation is successful if the error list is empty.
  List<String> validate(List args) {
    if (args.length != _expected.length) {
      return ['${_expected.length} argument(s) expected, found ${args.length}'];
    }
    return Iterable<int>.generate(_expected.length)
        .expand((i) => _expected[i](args[i]).map((e) => 'Arg #$i: $e'))
        .toList();
  }
}
