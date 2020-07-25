import 'dart:convert';
import 'dart:io';

import 'package:jessie/jessie.dart';
import 'package:test/test.dart';

void main() {
  final store = jsonDecode(File('test/store.json').readAsStringSync());
  group('Basic', () {
    final path = JsonPath('store.book[0].title');
    test('Filtering', () {
      expect(path.filter(store).single, 'Sayings of the Century');
    });
    test('toString()', () {
      expect(path.toString(), r"$['store']['book'][0]['title']");
    });
  });

  group('Tokenizer', () {
    test('Basic', () {
      expect(tokenize('store.book[0].title').join(), 'store.book[0].title');
    });
  });
}

class JsonPath {
  factory JsonPath(String path) {
    final tokens = tokenize(path);
    if (tokens.isNotEmpty && tokens.first == const Root()) {
      tokens.removeAt(0);
    }

    var filter = const Neutral();

    return JsonPath._(
        Neutral() | Field('store') | Field('book') | Index(0) | Field('title'));
  }

  JsonPath._(this._filter);

  final Filter _filter;

  /// Filters the given [json].
  /// Returns an Iterable of all elements found
  Iterable filter(json) => _filter.call([json]);

  @override
  String toString() => _filter.toString();
}
