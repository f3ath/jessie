import 'package:json_path/src/expression/nodes.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/grammar/fun_name.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:petitparser/petitparser.dart';

class FunValidator {
  /// Validates the function and returns all issues found.
  /// An empty return means a successful validation.
  Iterable<String> errors(Fun f) sync* {
    if (!funName.allMatches(f.name).contains(f.name)) {
      yield 'Invalid function name ${f.name}';
    }
    if (f is Fun1) {
      if (f is! Fun1<bool, dynamic> &&
          f is! Fun1<Maybe, dynamic> &&
          f is! Fun1<Nodes, dynamic>) {
        yield 'Invalid return type in function ${f.name}';
      }
      if (f is! Fun1<dynamic, Maybe> &&
          f is! Fun1<dynamic, Nodes> &&
          f is! Fun1<dynamic, bool>) {
        yield 'Invalid type of the first argument in function ${f.name}';
      }
    } else if (f is Fun2) {
      if (f is! Fun2<bool, dynamic, dynamic> &&
          f is! Fun2<Maybe, dynamic, dynamic> &&
          f is! Fun2<Nodes, dynamic, dynamic>) {
        yield 'Invalid return type in function ${f.name}';
      }
      if (f is! Fun2<dynamic, bool, dynamic> &&
          f is! Fun2<dynamic, Maybe, dynamic> &&
          f is! Fun2<dynamic, Nodes, dynamic>) {
        yield 'Invalid type of the first argument in function ${f.name}';
      }
      if (f is! Fun2<dynamic, dynamic, bool> &&
          f is! Fun2<dynamic, dynamic, Maybe> &&
          f is! Fun2<dynamic, dynamic, Nodes>) {
        yield 'Invalid type of the second argument in function ${f.name}';
      }
    } else {
      yield 'Unexpected function type ${f.runtimeType}';
    }
  }
}
