import 'dart:convert';
import 'dart:io';

import 'package:json_path/json_pointer.dart';
import 'package:test/test.dart';

void main() {
  group('Parsing', () {
    test('invalid format', () {
      expect(() => JsonPointer.parse('a'), throwsFormatException);
      expect(() => JsonPointer.parse('/~'), throwsFormatException);
      expect(() => JsonPointer.parse('/~3'), throwsFormatException);
      expect(() => JsonPointer.parse('/~~'), throwsFormatException);
      expect(() => JsonPointer.parse('/foo~~'), throwsFormatException);
      expect(() => JsonPointer.parse('/~a~0'), throwsFormatException);
      expect(() => JsonPointer.parse('/~~0'), throwsFormatException);
    });
  });
  group('Building', () {
    test('root', () {
      expect(JsonPointer().toString(), '');
    });
    test('root + field', () {
      expect(JsonPointer().append('foo').toString(), '/foo');
    });
    test('root + /', () {
      expect(JsonPointer().append('/').toString(), '/~1');
    });
    test('root + / + foo + ~0 + 0', () {
      expect(JsonPointer.buildWritable(['/', 'foo', '~0', '0']).toString(),
          '/~1/foo/~00/0');
    });
  });

  group('Reading', () {
    final json = jsonDecode(File('test/store.json').readAsStringSync());
    test('root', () {
      expect(JsonPointer().read(json), json);
    });
    test('array index', () {
      final doc = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
      expect(JsonPointer.parse('/10').read(doc), 10);
      expect(JsonPointer.parse('/0').read(doc), 0);
      expect(JsonPointer.parse('/1').read(doc), 1);
      expect(JsonPointer.parse('/9').read(doc), 9);
      expect(() => JsonPointer.parse('/01').read(doc), throwsException);
      expect(() => JsonPointer.parse('/00').read(doc), throwsException);
    });
    test('/-2', () {
      final doc = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
      expect(() => JsonPointer.parse('/-2').read(doc),
          throwsA(predicate((e) => e is InvalidRoute)));
    });
    test('/store/book/1/title', () {
      expect(JsonPointer.parse('/store/book/1/title').read(json),
          'Sword of Honour');
    });
    test('/does/not/exist', () {
      expect(JsonPointer.parse('/does/not/exist').read(json, orElse: () => 42),
          42);
    });
    test('/store/book/1', () {
      expect(JsonPointer.parse('/store/book/1').read(json),
          json['store']['book'][1]);
    });
    test('/store/book/- throws not found', () {
      expect(
          () => JsonPointer.parse('/store/book/-').read(json),
          throwsA(predicate((e) =>
              e is InvalidRoute && e.toString().contains('/store/book/-'))));
    });
    test('- works on objects', () {
      expect(JsonPointer.parse('/-').read({'-': 'foo'}), 'foo');
    });
    test('numerical keys work on objects', () {
      expect(JsonPointer().append('1').read({'1': 'foo'}), 'foo');
    });
    test('/store/book/01/title throws not found', () {
      expect(
          () => JsonPointer.parse('/store/book/01/title').read(json),
          throwsA(predicate((e) =>
              e is InvalidRoute && e.toString().contains('/store/book/01'))));
    });
    test('special chars', () {
      final doc = {
        r'': 0,
        r'\': 1,
        r'a\t': 2,
        r'/': 3,
        r'\u0123': 4,
        r'"foo"': 5,
        r'~bar': 6,
        r'/~/': 7,
        r'\~': 8,
        r"\'~": 9,
        ' ': 10,
        '\t': 11,
        '-2': 12,
        '0': 13,
        '00': 14,
        '01': 15,
      };
      expect(JsonPointer.parse('/').read(doc), 0);
      expect(JsonPointer.parse(r'/\').read(doc), 1);
      expect(JsonPointer.parse(r'/a\t').read(doc), 2);
      expect(JsonPointer.parse(r'/~1').read(doc), 3);
      expect(JsonPointer.parse(r'/\u0123').read(doc), 4);
      expect(JsonPointer.parse(r'/"foo"').read(doc), 5);
      expect(JsonPointer.parse(r'/~0bar').read(doc), 6);
      expect(JsonPointer.parse(r'/~1~0~1').read(doc), 7);
      expect(JsonPointer.parse(r'/\~0').read(doc), 8);
      expect(JsonPointer.parse(r"/\'~0").read(doc), 9);
      expect(JsonPointer.parse(r'/ ').read(doc), 10);
      expect(JsonPointer.parse('/\t').read(doc), 11);
      expect(JsonPointer.parse('/-2').read(doc), 12);
      expect(JsonPointer.parse('/0').read(doc), 13);
      expect(JsonPointer.parse('/00').read(doc), 14);
      expect(JsonPointer.parse('/01').read(doc), 15);
    });
  });

  group('Writing', () {
    Map? json;
    setUp(() {
      json = jsonDecode(File('test/store.json').readAsStringSync());
    });
    test('write on primitive', () {
      expect(
          () => JsonPointer.parseWritable('/0').write('foo', 'bar'),
          throwsA(predicate(
              (e) => e is InvalidRoute && e.toString().contains('/0'))));
    });
    test('/store/book/1/title', () {
      final p = JsonPointer.parseWritable('/store/book/1/title');
      p.write(json, 'banana');
      expect(p.read(json), 'banana');
    });
    test('create a new child', () {
      JsonPointer.parseWritable('/store/book/1/color').write(json, 'blue');
      expect(JsonPointer.parse('/store/book/1/color').read(json), 'blue');
    });
    test('/store/book/2', () {
      JsonPointer.parseWritable('/store/book/2').write(json, 'banana');
      expect(JsonPointer.parse('/store/book/2').read(json), 'banana');
    });
    test('/store/book/-', () {
      JsonPointer.parseWritable('/store/book/-').write(json, 'banana');
      expect(JsonPointer.parse('/store/book').read(json).last, 'banana');
    });
    test('/store/book/0/-', () {
      JsonPointer.parseWritable('/store/book/0/-').write(json, 'banana');
      expect(JsonPointer.parse('/store/book/0/-').read(json), 'banana');
    });
    test('/store/book/01/title throws not found', () {
      expect(
          () => JsonPointer.parseWritable('/store/book/01/title')
              .write(json, 'foo'),
          throwsA(predicate((e) =>
              e is InvalidRoute && e.toString().contains('/store/book/01'))));
    });
  });
}
