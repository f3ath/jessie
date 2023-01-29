import 'package:json_path/json_path.dart';
import 'package:test/test.dart';

void main() {
  test('Expr', () {
    final document = [
      {"foo": 1, "bar": 2},
      {"foo": 42, "bar": 42},
      {"foo": 1, "bro": 1},
      {}
    ];
    final path = JsonPath(r"$[?(@.foo < @.bar)]");
    print(path.read(document));
  });
}
