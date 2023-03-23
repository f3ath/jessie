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
      if (f is! Fun1<bool, Object> &&
          f is! Fun1<Maybe, Object> &&
          f is! Fun1<Nodes, Object>) {
        yield 'Invalid return type in function ${f.name}';
      }
      if (f is! Fun1<Object, Maybe> &&
          f is! Fun1<Object, Nodes> &&
          f is! Fun1<Object, bool>) {
        yield 'Invalid type of the first argument in function ${f.name}';
      }
    } else if (f is Fun2) {
      if (f is! Fun2<bool, Object, Object> &&
          f is! Fun2<Maybe, Object, Object> &&
          f is! Fun2<Nodes, Object, Object>) {
        yield 'Invalid return type in function ${f.name}';
      }
      if (f is! Fun2<Object, bool, Object> &&
          f is! Fun2<Object, Maybe, Object> &&
          f is! Fun2<Object, Nodes, Object>) {
        yield 'Invalid type of the first argument in function ${f.name}';
      }
      if (f is! Fun2<Object, Object, bool> &&
          f is! Fun2<Object, Object, Maybe> &&
          f is! Fun2<Object, Object, Nodes>) {
        yield 'Invalid type of the second argument in function ${f.name}';
      }
    } else {
      yield 'Unexpected function type ${f.runtimeType}';
    }
  }
}
