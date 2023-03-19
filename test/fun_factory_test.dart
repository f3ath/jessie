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
    test('throws on invalid return type', () {
      expect(() => FunFactory([BadReturnType1Fun()]), throwsArgumentError);
      expect(() => FunFactory([BadReturnType2Fun()]), throwsArgumentError);
    });

    test('throws on invalid arg type', () {
      expect(() => FunFactory([BadFirstArg1Fun()]), throwsArgumentError);
      expect(() => FunFactory([BadFirstArg2Fun()]), throwsArgumentError);
      expect(() => FunFactory([BadSecondArg2Fun()]), throwsArgumentError);
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

class BadReturnType1Fun extends Fun1<int, bool> {
  @override
  final name = 'bad';

  @override
  int apply(bool a) => 42;
}

class BadFirstArg1Fun extends Fun1<bool, int> {
  @override
  final name = 'bad';

  @override
  bool apply(int a) => true;
}

class BadReturnType2Fun extends Fun2<int, bool, bool> {
  @override
  final name = 'bad';

  @override
  int apply(bool a, bool b) => 42;
}

class BadFirstArg2Fun extends Fun2<bool, int, bool> {
  @override
  final name = 'bad';

  @override
  bool apply(int a, bool b) => true;
}

class BadSecondArg2Fun extends Fun2<bool, bool, int> {
  @override
  final name = 'bad';

  @override
  bool apply(bool a, int b) => true;
}

