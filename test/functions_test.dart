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
    test('Nodes', () {
      parser.parse(r'$[?count(siblings(@)) > 1]').readValues(store);

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
      arg.map((nodes) => nodes.expand((node) {
            final parent = node.parent;
            if (parent == null) return <Node>[];
            return selectAll(parent).where((it) => it != node);
          }));
    }
    throw Exception('Invalid arg type');
  }
}
