import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/fun/fun_factory.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:test/test.dart';

void main() {
  group('FunFactory', () {
    test('throws on incorrect fun type', () {
      expect(() => FunFactory([ForbiddenFun()]), throwsArgumentError);
    });
    test('throws on incorrect fun name', () {
      expect(() => FunFactory([BadNameFun()]), throwsArgumentError);
    });
  });
}

class ForbiddenFun extends Fun {
  @override
  final name = 'oops';
}

class BadNameFun extends Fun1<bool, Maybe> {
  @override
  final name = 'Foo';

  @override
  bool apply(Maybe a) => true;
}
