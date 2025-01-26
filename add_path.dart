import 'dart:convert';
import 'dart:io';

import 'package:json_path/json_path.dart';

void main() {
  const repo = '../jsonpath-compliance-test-suite/tests/';

  Directory(repo)
      .listSync()
      .whereType<File>()
      .where((file) =>
          file.path.endsWith('.json') && !file.path.endsWith('.schema.json'))
      .forEach((file) {
    print(file.path);

    final cases = jsonDecode(file.readAsStringSync());
    for (final Map t in cases['tests'] as List) {
      if (t.containsKey('result')) {
        t['result_paths'] = JsonPath(t['selector'])
            .read(t['document'])
            .map((it) => it.path)
            .toList();
      }
      if (t.containsKey('results')) {
        final paths = [];
        final myResult =
            JsonPath(t['selector']).readValues(t['document']).toList();
        final myPaths = JsonPath(t['selector'])
            .read(t['document'])
            .map((it) => it.path)
            .toList();
        print(t['results']);
        print(t['results'].length);
        print('myResult $myResult');
        for (List r in t['results']) {
          for (var p in perms(r.length)) {
            if (eq(permute(myResult, p), r)) {
              print('Perm: $p');
              paths.add(permute(myPaths, p));
            }
          }
        }
        t['results_paths'] = paths;
      }
    }
    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(cases));
    print('Wrote ${file.path}');
  });
}

bool eq(a, b) =>
    (a == b) ||
    (a is List &&
        b is List &&
        a.length == b.length &&
        List.generate(a.length, (i) => eq(a[i], b[i])).every((i) => i)) ||
    (a is Map &&
        b is Map &&
        a.keys.length == b.keys.length &&
        a.keys.every((k) => b.containsKey(k) && eq(a[k], b[k])));

List<List<int>> perms(int n) =>
    allPermutations(List<int>.generate(n, (i) => i));

List<T> permute<T>(List<T> list, List<int> order) {
  final result = <T>[];
  for (var i in order) {
    result.add(list[i]);
  }
  return result;
}

List<List<T>> allPermutations<T>(List<T> list) {
  if (list.isEmpty) {
    return [[]];
  }

  List<List<T>> permutations = [];
  for (int i = 0; i < list.length; i++) {
    T current = list[i];
    List<T> remaining = List.from(list)..removeAt(i);
    List<List<T>> subPermutations = allPermutations(remaining);
    for (var perm in subPermutations) {
      permutations.add([current, ...perm]);
    }
  }
  return permutations;
}
