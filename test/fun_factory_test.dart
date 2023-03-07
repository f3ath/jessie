import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/fun/fun_factory.dart';
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

class ForbiddenFun extends Fun<int> {
  @override
  final name = 'oops';

  @override
  Expression<int> toExpression(List<Expression> args) => Expression((_) => 42);
}

class BadNameFun extends Fun<bool> {
  @override
  final name = 'Foo';

  @override
  Expression<bool> toExpression(List<Expression> args) =>
      Expression((_) => true);
}
