import 'dart:convert';
import 'dart:io';

import 'package:json_path/json_path.dart';
import 'package:test/test.dart';

void main() {
  final json = jsonDecode(File('test/store.json').readAsStringSync());
  test('Root element', () {
    final root = JsonPath(r'$');
    expect(root.set(json, 'foo'), 'foo');
  });
  group('Field', () {
    final store = JsonPath(r'$.store');
    test('Replaces existing field', () {
      expect(store.set(json, 'foo'), {'store': 'foo'});
    });
    test('Can be nested', () {
      final color = JsonPath(r'$.store.bicycle.color');
      final mutated = color.set(json, 'blue') as dynamic;
      expect(mutated['store']['bicycle']['color'], 'blue');
      expect(mutated['store']['bicycle']['price'],
          json['store']['bicycle']['price']);
      expect(mutated['store']['book'], json['store']['book']);
      expect(json['store']['bicycle']['color'], 'red',
          reason: 'Original bike is still red');
    });
    test('Does not set non-existing field', () {
      final foo = JsonPath(r'$.foo');
      final mutated = foo.set(json, 42);
      expect(mutated.containsKey('foo'), false);
      expect(mutated['store'], json['store']);
    });
    test('Does not change non-object (scalars, arrays)', () {
      expect(store.set(42, 'foo'), 42);
      expect(store.set([true], 'foo'), [true]);
    });
  });

  test('Recursive. Set all prices to 0', () {
    final prices = JsonPath(r'$..price');
    final mutated = prices.set(json, 0);
    expect(mutated['store']['bicycle']['price'], 0);
    expect(mutated['store']['book'][0]['price'], 0);
    expect(mutated['store']['book'][1]['price'], 0);
    expect(mutated['store']['book'][2]['price'], 0);
    expect(mutated['store']['book'][3]['price'], 0);
  });

  test('Filter. Hide prices which are too high', () {
    final prices = JsonPath(r'$..price[?high]',
        filter: {'high': (_) => _ is num && _ > 15});
    final mutated = prices.set(json, 'hidden');
    expect(mutated['store']['bicycle']['price'], 'hidden');
    expect(mutated['store']['book'][0]['price'], 8.95);
    expect(mutated['store']['book'][3]['price'], 'hidden');
  });

  group('Index', () {
    test('Index. Hide the prices of the fist book', () {
      final price = JsonPath(r'$.store.book[0].price');
      final mutated = price.set(json, 'hidden');
      expect(mutated['store']['bicycle']['price'], isA<num>());
      expect(mutated['store']['book'][0]['price'], 'hidden');
      expect(mutated['store']['book'][1]['price'], isA<num>());
      expect(mutated['store']['book'][2]['price'], isA<num>());
      expect(mutated['store']['book'][3]['price'], isA<num>());
    });
    test('Index. Hide the prices of the second and last books', () {
      final price = JsonPath(r'$.store.book[1,3].price');
      final mutated = price.set(json, 'hidden');
      expect(mutated['store']['bicycle']['price'], isA<num>());
      expect(mutated['store']['book'][0]['price'], isA<num>());
      expect(mutated['store']['book'][1]['price'], 'hidden');
      expect(mutated['store']['book'][2]['price'], isA<num>());
      expect(mutated['store']['book'][3]['price'], 'hidden');
    });
  });
}
