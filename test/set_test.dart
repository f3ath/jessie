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
    test('Creates a field if it does not exist', () {
      final abc = JsonPath(r'$.a.b.c');
      final mutated = abc.set({'foo': 'bar'}, 'magic');
      expect(mutated['foo'], 'bar');
      expect(mutated['a']['b']['c'], 'magic');
    });
    test('Does not change non-object (scalars, arrays)', () {
      expect(store.set(42, 'foo'), 42);
      expect(store.set([true], 'foo'), [true]);
    });
    test('Replace all bicycle fields with a banana', () {
      final bikeFields = JsonPath(r'$.store.bicycle.*');
      final mutated = bikeFields.set(json, 'banana');
      expect(mutated['store']['bicycle']['color'], 'banana');
      expect(mutated['store']['bicycle']['price'], 'banana');
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
    test('Index. Hide the prices of all books', () {
      final price = JsonPath(r'$.store.book[*].price');
      final mutated = price.set(json, 'hidden');
      expect(mutated['store']['book'][0]['price'], 'hidden');
      expect(mutated['store']['book'][1]['price'], 'hidden');
      expect(mutated['store']['book'][2]['price'], 'hidden');
      expect(mutated['store']['book'][3]['price'], 'hidden');
    });
    test('Index. Replace every other book with a banana', () {
      final price = JsonPath(r'$.store.book[::2]');
      final mutated = price.set(json, 'banana');
      expect(mutated['store']['book'][0], 'banana');
      expect(mutated['store']['book'][1]['price'], isA<num>());
      expect(mutated['store']['book'][2], 'banana');
      expect(mutated['store']['book'][3]['price'], isA<num>());
    });
    test('Index. Setting non-existing index throws RangeError', () {
      final title = JsonPath(r'$.store.book[100].title');
      expect(() => title.set(json, 'Banana'), throwsRangeError);
    });
  });
}
