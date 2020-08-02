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
      expect(root.select(json).single.value, json);
      expect(root.select(json).single.path, r'$');
    });

    test('Single field', () {
      final store = JsonPath(r'$.store');
      expect(store.toString(), r"$['store']");
      expect(store.select(json).single.value, json['store']);
      expect(store.select(json).single.path, r"$['store']");
    });

    test('Single field in bracket notation', () {
      final store = JsonPath(r"$['store']");
      expect(store.toString(), r"$['store']");
      expect(store.select(json).single.value, json['store']);
      expect(store.select(json).single.path, r"$['store']");
    });

    test('Mixed brackets and fields', () {
      final price = JsonPath(r"$['store'].bicycle['price']");
      expect(price.toString(), r"$['store']['bicycle']['price']");
      expect(
          price.select(json).single.value, json['store']['bicycle']['price']);
      expect(price.select(json).single.path, r"$['store']['bicycle']['price']");
    });
  });

  group('Invalid format', () {
    test('Unmatched quote', () {
      expect(() => JsonPath(r"$['hello"), throwsFormatException);
      expect(() => JsonPath(r"$['hello\"), throwsFormatException);
    });
    test('Empty', () {
      expect(() => JsonPath(''), throwsFormatException);
    });
  });

  group('Slices', () {
    final abc = 'abcdefg'.split('');
    test('1:3', () {
      final slice = JsonPath(r'$[1:3]');
      expect(slice.toString(), r'$[1:3]');
      expect(slice.select(abc).length, 2);
      expect(slice.select(abc).first.value, 'b');
      expect(slice.select(abc).first.path, r'$[1]');
      expect(slice.select(abc).last.value, 'c');
      expect(slice.select(abc).last.path, r'$[2]');
    });
    test('1:5:2', () {
      final slice = JsonPath(r'$[1:5:2]');
      expect(slice.toString(), r'$[1:5:2]');
      expect(slice.select(abc).length, 2);
      expect(slice.select(abc).first.value, 'b');
      expect(slice.select(abc).first.path, r'$[1]');
      expect(slice.select(abc).last.value, 'd');
      expect(slice.select(abc).last.path, r'$[3]');
    });
    test('1:5:-2', () {
      final slice = JsonPath(r'$[1:5:-2]');
      expect(slice.toString(), r'$[1:5:-2]');
      expect(slice.select(abc).length, 0);
    });
    test(':3', () {
      final slice = JsonPath(r'$[:3]');
      expect(slice.toString(), r'$[:3]');
      expect(slice.select(abc).length, 3);
      expect(slice.select(abc).first.value, 'a');
      expect(slice.select(abc).first.path, r'$[0]');
      expect(slice.select(abc).last.value, 'c');
      expect(slice.select(abc).last.path, r'$[2]');
    });
    test(':3:2', () {
      final slice = JsonPath(r'$[:3:2]');
      expect(slice.toString(), r'$[:3:2]');
      expect(slice.select(abc).length, 2);
      expect(slice.select(abc).first.value, 'a');
      expect(slice.select(abc).first.path, r'$[0]');
      expect(slice.select(abc).last.value, 'c');
      expect(slice.select(abc).last.path, r'$[2]');
    });
    test('3::2', () {
      final slice = JsonPath(r'$[3::2]');
      expect(slice.toString(), r'$[3::2]');
      expect(slice.select(abc).length, 2);
      expect(slice.select(abc).first.value, 'd');
      expect(slice.select(abc).first.path, r'$[3]');
      expect(slice.select(abc).last.value, 'f');
      expect(slice.select(abc).last.path, r'$[5]');
    });
    test('100:', () {
      final slice = JsonPath(r'$[100:]');
      expect(slice.toString(), r'$[100:]');
      expect(slice.select(abc).length, 0);
    });
    test('3:', () {
      final slice = JsonPath(r'$[3:]');
      expect(slice.toString(), r'$[3:]');
      expect(slice.select(abc).length, 4);
      expect(slice.select(abc).first.value, 'd');
      expect(slice.select(abc).first.path, r'$[3]');
      expect(slice.select(abc).last.value, 'g');
      expect(slice.select(abc).last.path, r'$[6]');
    });
    test(':-5', () {
      final slice = JsonPath(r'$[:-5]');
      expect(slice.toString(), r'$[:-5]');
      expect(slice.select(abc).length, 2);
      expect(slice.select(abc).first.value, 'a');
      expect(slice.select(abc).first.path, r'$[0]');
      expect(slice.select(abc).last.value, 'b');
      expect(slice.select(abc).last.path, r'$[1]');
    });

    test('-5:', () {
      final slice = JsonPath(r'$[-5:]');
      expect(slice.toString(), r'$[-5:]');
      expect(slice.select(abc).length, 5);
      expect(slice.select(abc).first.value, 'c');
      expect(slice.select(abc).first.path, r'$[2]');
      expect(slice.select(abc).last.value, 'g');
      expect(slice.select(abc).last.path, r'$[6]');
    });
    test('0:6', () {
      final slice = JsonPath(r'$[0:6]');
      expect(slice.toString(), r'$[:6]');
      expect(slice.select(abc).length, 6);
      expect(slice.select(abc).first.value, 'a');
      expect(slice.select(abc).first.path, r'$[0]');
      expect(slice.select(abc).last.value, 'f');
      expect(slice.select(abc).last.path, r'$[5]');
    });
    test('0:100', () {
      final slice = JsonPath(r'$[0:100]');
      expect(slice.toString(), r'$[:100]');
      expect(slice.select(abc).length, 7);
      expect(slice.select(abc).first.value, 'a');
      expect(slice.select(abc).first.path, r'$[0]');
      expect(slice.select(abc).last.value, 'g');
      expect(slice.select(abc).last.path, r'$[6]');
    });

    test('-6:-1', () {
      final slice = JsonPath(r'$[-6:-1]');
      expect(slice.toString(), r'$[-6:-1]');
      expect(slice.select(abc).length, 5);
      expect(slice.select(abc).first.value, 'b');
      expect(slice.select(abc).first.path, r'$[1]');
      expect(slice.select(abc).last.value, 'f');
      expect(slice.select(abc).last.path, r'$[5]');
    });
  });

  group('Uncommon brackets', () {
    test('Escape single quote', () {
      final j = {r"sq'sq s\s qs\'qs": 'value'};
      final path = JsonPath(r"$['sq\'sq s\\s qs\\\'qs']");
      final select = path.select(j);
      expect(select.single.value, 'value');
      expect(select.single.path, r"$['sq\'sq s\\s qs\\\'qs']");
    });
  });

//  group('Union', () {
//    test('Array', () {
////      final abc = 'abcdefg'.split('');
//      final union = JsonPath(r'$[2,3,5]');
//      expect(union.toString(), r'$[2,3,5]');
//    });
//  });

  group('Wildcards', () {
    test('All in root', () {
      final allInRoot = JsonPath(r'$.*');
      expect(allInRoot.toString(), r'$.*');
      expect(allInRoot.select(json).single.value, json['store']);
      expect(allInRoot.select(json).single.path, r"$['store']");
    });

    test('All in store', () {
      final allInStore = JsonPath(r'$.store.*');
      expect(allInStore.toString(), r"$['store'].*");
      expect(allInStore.select(json).length, 2);
      expect(allInStore.select(json).first.value, json['store']['book']);
      expect(allInStore.select(json).first.path, r"$['store']['book']");
      expect(allInStore.select(json).last.value, json['store']['bicycle']);
      expect(allInStore.select(json).last.path, r"$['store']['bicycle']");
    });
  });

  group('Recursion', () {
    test('Recursive', () {
      final allNode = JsonPath(r'$..');
      expect(allNode.toString(), r'$..');
      expect(allNode.select(json).length, 8);
      expect(allNode.select(json).first.value, json);
      expect(allNode.select(json).first.path, r'$');
      expect(allNode.select(json).last.value, json['store']['bicycle']);
      expect(allNode.select(json).last.path, r"$['store']['bicycle']");
    });

    test('Recursive with all values', () {
      final path = JsonPath(r'$..*');
      expect(path.toString(), r'$..*');
      expect(path.select(json).length, 27);
      expect(path.select(json).first.value, json['store']);
      expect(path.select(json).first.path, r"$['store']");
      expect(path.select(json).last.value, json['store']['bicycle']['price']);
      expect(path.select(json).last.path, r"$['store']['bicycle']['price']");
    });

    test('Every price tag', () {
      final path = JsonPath(r'$..price');
      expect(path.toString(), r"$..['price']");
      expect(path.select(json).length, 5);
      expect(path.select(json).first.value, json['store']['book'][0]['price']);
      expect(path.select(json).first.path, r"$['store']['book'][0]['price']");
      expect(path.select(json).last.value, json['store']['bicycle']['price']);
      expect(path.select(json).last.path, r"$['store']['bicycle']['price']");
    });
  });

  group('Arrays', () {
    test('Path with an index', () {
      final path = JsonPath(r'$.store.book[0].title');
      expect(path.toString(), r"$['store']['book'][0]['title']");
      expect(path.select(json).single.value, 'Sayings of the Century');
      expect(path.select(json).single.path, r"$['store']['book'][0]['title']");
    });

    test('All in array', () {
      final path = JsonPath(r'$.store.book[*]');
      expect(path.toString(), r"$['store']['book'][*]");
      expect(path.select(json).length, 4);
      expect(path.select(json).first.value, json['store']['book'][0]);
      expect(path.select(json).first.path, r"$['store']['book'][0]");
      expect(path.select(json).last.value, json['store']['book'][3]);
      expect(path.select(json).last.path, r"$['store']['book'][3]");
    });
  });
}
