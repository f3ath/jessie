import 'dart:convert';
import 'dart:io';

import 'package:jessie/jessie.dart';
import 'package:test/test.dart';

void main() {
  final store = jsonDecode(File('test/store.json').readAsStringSync());
  group('Basic', () {
    final path = Field('store') | Field('book') | Index(0) | Field('title');
    test('filtering', () {
      expect(path.filter(store).single, 'Sayings of the Century');
    });
    test('toString()', () {
      expect(path.toString(), "['store']['book'][0]['title']");
    });
  });
}
