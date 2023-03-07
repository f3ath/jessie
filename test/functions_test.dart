import 'dart:convert';
import 'dart:io';

import 'package:json_path/functions.dart';
import 'package:json_path/json_path.dart';
import 'package:json_path/src/grammar/select_all.dart';
import 'package:json_path/src/node/node.dart';
import 'package:test/test.dart';

void main() {
  final store = jsonDecode(File('test/store.json').readAsStringSync());
  final parser = JsonPathParser(userFunctions: [Siblings()]);
  group('User-defined functions', () {
    test('Fun<Nodes>', () {
      expect(
          parser
              .parse(r'$..[?count(siblings(@)) > 4]')
              .readValues(store)
              .toList(),
          equals([
            'fiction',
            'Herman Melville',
            'Moby Dick',
            '0-553-21311-3',
            8.99,
            'fiction',
            'J. R. R. Tolkien',
            'The Lord of the Rings',
            '0-395-19395-8',
            22.99,
          ]));
    });
    test('Fun<Nodes> in Nodes context', () {
      expect(
          parser
              .parse(r'$..[?count(siblings(siblings(@))) > 4]')
              .readValues(store)
              .length,
          equals(22));
    });
  });
}

/// Returns all siblings of the given nodes.
class Siblings implements Fun<Nodes> {
  @override
  final name = 'siblings';

  @override
  Expression<Nodes> toExpression(List<Expression> args) {
    final arg = args.single;
    if (arg is Expression<Nodes>) {
      return arg.map((nodes) => nodes.expand((node) {
            final parent = node.parent;
            if (parent == null) return <Node>[];
            return selectAll(parent).where((it) => it != node);
          }));
    }
    throw Exception('Invalid arg type');
  }
}
