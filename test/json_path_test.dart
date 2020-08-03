import 'dart:convert';
import 'dart:io';

import 'package:json_path/json_path.dart';
import 'package:test/test.dart';

void main() {
  final json = jsonDecode(File('test/store.json').readAsStringSync());
  group('Basic expressions', () {
    test('Only root', () {
      final root = JsonPath(r'$');
      expect(root.toString(), r'$');
      expect(root.filter(json).single.value, json);
      expect(root.filter(json).single.path, r'$');
    });

    test('Single field', () {
      final store = JsonPath(r'$.store');
      expect(store.toString(), r"$['store']");
      expect(store.filter(json).single.value, json['store']);
      expect(store.filter(json).single.path, r"$['store']");
    });

    test('Single field in bracket notation', () {
      final store = JsonPath(r"$['store']");
      expect(store.toString(), r"$['store']");
      expect(store.filter(json).single.value, json['store']);
      expect(store.filter(json).single.path, r"$['store']");
    });

    test('Mixed brackets and fields', () {
      final price = JsonPath(r"$['store'].bicycle['price']");
      expect(price.toString(), r"$['store']['bicycle']['price']");
      expect(
          price.filter(json).single.value, json['store']['bicycle']['price']);
      expect(price.filter(json).single.path, r"$['store']['bicycle']['price']");
    });
  });

  group('Invalid format', () {
    test('Empty', () {
      expect(() => JsonPath(''), throwsFormatException);
    });
  });

  group('Slices', () {
    final abc = 'abcdefg'.split('');
    test('1:3', () {
      final slice = JsonPath(r'$[1:3]');
      expect(slice.toString(), r'$[1:3]');
      expect(slice.filter(abc).length, 2);
      expect(slice.filter(abc).first.value, 'b');
      expect(slice.filter(abc).first.path, r'$[1]');
      expect(slice.filter(abc).last.value, 'c');
      expect(slice.filter(abc).last.path, r'$[2]');
    });
    test('1:5:2', () {
      final slice = JsonPath(r'$[1:5:2]');
      expect(slice.toString(), r'$[1:5:2]');
      expect(slice.filter(abc).length, 2);
      expect(slice.filter(abc).first.value, 'b');
      expect(slice.filter(abc).first.path, r'$[1]');
      expect(slice.filter(abc).last.value, 'd');
      expect(slice.filter(abc).last.path, r'$[3]');
    });
    test('1:5:-2', () {
      final slice = JsonPath(r'$[1:5:-2]');
      expect(slice.toString(), r'$[1:5:-2]');
      expect(slice.filter(abc).length, 0);
    });
    test(':3', () {
      final slice = JsonPath(r'$[:3]');
      expect(slice.toString(), r'$[:3]');
      expect(slice.filter(abc).length, 3);
      expect(slice.filter(abc).first.value, 'a');
      expect(slice.filter(abc).first.path, r'$[0]');
      expect(slice.filter(abc).last.value, 'c');
      expect(slice.filter(abc).last.path, r'$[2]');
    });
    test(':3:2', () {
      final slice = JsonPath(r'$[:3:2]');
      expect(slice.toString(), r'$[:3:2]');
      expect(slice.filter(abc).length, 2);
      expect(slice.filter(abc).first.value, 'a');
      expect(slice.filter(abc).first.path, r'$[0]');
      expect(slice.filter(abc).last.value, 'c');
      expect(slice.filter(abc).last.path, r'$[2]');
    });
    test('3::2', () {
      final slice = JsonPath(r'$[3::2]');
      expect(slice.toString(), r'$[3::2]');
      expect(slice.filter(abc).length, 2);
      expect(slice.filter(abc).first.value, 'd');
      expect(slice.filter(abc).first.path, r'$[3]');
      expect(slice.filter(abc).last.value, 'f');
      expect(slice.filter(abc).last.path, r'$[5]');
    });
    test('100:', () {
      final slice = JsonPath(r'$[100:]');
      expect(slice.toString(), r'$[100:]');
      expect(slice.filter(abc).length, 0);
    });
    test('3:', () {
      final slice = JsonPath(r'$[3:]');
      expect(slice.toString(), r'$[3:]');
      expect(slice.filter(abc).length, 4);
      expect(slice.filter(abc).first.value, 'd');
      expect(slice.filter(abc).first.path, r'$[3]');
      expect(slice.filter(abc).last.value, 'g');
      expect(slice.filter(abc).last.path, r'$[6]');
    });
    test(':-5', () {
      final slice = JsonPath(r'$[:-5]');
      expect(slice.toString(), r'$[:-5]');
      expect(slice.filter(abc).length, 2);
      expect(slice.filter(abc).first.value, 'a');
      expect(slice.filter(abc).first.path, r'$[0]');
      expect(slice.filter(abc).last.value, 'b');
      expect(slice.filter(abc).last.path, r'$[1]');
    });

    test('-5:', () {
      final slice = JsonPath(r'$[-5:]');
      expect(slice.toString(), r'$[-5:]');
      expect(slice.filter(abc).length, 5);
      expect(slice.filter(abc).first.value, 'c');
      expect(slice.filter(abc).first.path, r'$[2]');
      expect(slice.filter(abc).last.value, 'g');
      expect(slice.filter(abc).last.path, r'$[6]');
    });
    test('0:6', () {
      final slice = JsonPath(r'$[0:6]');
      expect(slice.toString(), r'$[:6]');
      expect(slice.filter(abc).length, 6);
      expect(slice.filter(abc).first.value, 'a');
      expect(slice.filter(abc).first.path, r'$[0]');
      expect(slice.filter(abc).last.value, 'f');
      expect(slice.filter(abc).last.path, r'$[5]');
    });
    test('0:100', () {
      final slice = JsonPath(r'$[0:100]');
      expect(slice.toString(), r'$[:100]');
      expect(slice.filter(abc).length, 7);
      expect(slice.filter(abc).first.value, 'a');
      expect(slice.filter(abc).first.path, r'$[0]');
      expect(slice.filter(abc).last.value, 'g');
      expect(slice.filter(abc).last.path, r'$[6]');
    });

    test('-6:-1', () {
      final slice = JsonPath(r'$[-6:-1]');
      expect(slice.toString(), r'$[-6:-1]');
      expect(slice.filter(abc).length, 5);
      expect(slice.filter(abc).first.value, 'b');
      expect(slice.filter(abc).first.path, r'$[1]');
      expect(slice.filter(abc).last.value, 'f');
      expect(slice.filter(abc).last.path, r'$[5]');
    });
  });

  group('Uncommon brackets', () {
    test('Escape single quote', () {
      final j = {r"sq'sq s\s qs\'qs": 'value'};
      final path = JsonPath(r"$['sq\'sq s\\s qs\\\'qs']");
      expect(path.toString(), r"$['sq\'sq s\\s qs\\\'qs']");
      final select = path.filter(j);
      expect(select.single.value, 'value');
      expect(select.single.path, r"$['sq\'sq s\\s qs\\\'qs']");
    });
  });

  group('Union', () {
    test('List', () {
      final abc = 'abcdefg'.split('');
      final union = JsonPath(r'$[2,3,100,5]');
      expect(union.toString(), r'$[2,3,100,5]');
      expect(union.filter(abc).length, 3);
      expect(union.filter(abc).first.value, 'c');
      expect(union.filter(abc).first.path, r'$[2]');
      expect(union.filter(abc).last.value, 'f');
      expect(union.filter(abc).last.path, r'$[5]');
    });
    test('Object', () {
      final abc = {
        'a': 'A',
        'b': 'B',
        'c': 'C',
      };
      final union = JsonPath(r"$['a','x',c]");
      expect(union.toString(), r"$['a','x','c']");
      expect(union.filter(abc).length, 2);
      expect(union.filter(abc).first.value, 'A');
      expect(union.filter(abc).first.path, r"$['a']");
      expect(union.filter(abc).last.value, 'C');
      expect(union.filter(abc).last.path, r"$['c']");
    });
  });

  group('Wildcards', () {
    test('All in root', () {
      final allInRoot = JsonPath(r'$.*');
      expect(allInRoot.toString(), r'$.*');
      expect(allInRoot.filter(json).single.value, json['store']);
      expect(allInRoot.filter(json).single.path, r"$['store']");
    });

    test('All in store', () {
      final allInStore = JsonPath(r'$.store.*');
      expect(allInStore.toString(), r"$['store'].*");
      expect(allInStore.filter(json).length, 2);
      expect(allInStore.filter(json).first.value, json['store']['book']);
      expect(allInStore.filter(json).first.path, r"$['store']['book']");
      expect(allInStore.filter(json).last.value, json['store']['bicycle']);
      expect(allInStore.filter(json).last.path, r"$['store']['bicycle']");
    });
  });

  group('Recursion', () {
    test('Recursive', () {
      final allNode = JsonPath(r'$..');
      expect(allNode.toString(), r'$..');
      expect(allNode.filter(json).length, 8);
      expect(allNode.filter(json).first.value, json);
      expect(allNode.filter(json).first.path, r'$');
      expect(allNode.filter(json).last.value, json['store']['bicycle']);
      expect(allNode.filter(json).last.path, r"$['store']['bicycle']");
    });

    test('Recursive with all values', () {
      final path = JsonPath(r'$..*');
      expect(path.toString(), r'$..*');
      expect(path.filter(json).length, 27);
      expect(path.filter(json).first.value, json['store']);
      expect(path.filter(json).first.path, r"$['store']");
      expect(path.filter(json).last.value, json['store']['bicycle']['price']);
      expect(path.filter(json).last.path, r"$['store']['bicycle']['price']");
    });

    test('Every price tag', () {
      final path = JsonPath(r'$..price');
      expect(path.toString(), r"$..['price']");
      expect(path.filter(json).length, 5);
      expect(path.filter(json).first.value, json['store']['book'][0]['price']);
      expect(path.filter(json).first.path, r"$['store']['book'][0]['price']");
      expect(path.filter(json).last.value, json['store']['bicycle']['price']);
      expect(path.filter(json).last.path, r"$['store']['bicycle']['price']");
    });
  });

  group('Lists', () {
    test('Path with an index', () {
      final path = JsonPath(r'$.store.book[0].title');
      expect(path.toString(), r"$['store']['book'][0]['title']");
      expect(path.filter(json).single.value, 'Sayings of the Century');
      expect(path.filter(json).single.path, r"$['store']['book'][0]['title']");
    });

    test('All in list', () {
      final path = JsonPath(r'$.store.book[*]');
      expect(path.toString(), r"$['store']['book'][*]");
      expect(path.filter(json).length, 4);
      expect(path.filter(json).first.value, json['store']['book'][0]);
      expect(path.filter(json).first.path, r"$['store']['book'][0]");
      expect(path.filter(json).last.value, json['store']['book'][3]);
      expect(path.filter(json).last.path, r"$['store']['book'][3]");
    });
  });
}
