import 'dart:convert';

import 'package:json_path/json_path.dart';

void main() {
  final document = jsonDecode('''
{
  "store": {
    "book": [
      {
        "category": "reference",
        "author": "Nigel Rees",
        "title": "Sayings of the Century",
        "price": 8.95
      },
      {
        "category": "fiction",
        "author": "Evelyn Waugh",
        "title": "Sword of Honour",
        "price": 12.99
      },
      {
        "category": "fiction",
        "author": "Herman Melville",
        "title": "Moby Dick",
        "isbn": "0-553-21311-3",
        "price": 8.99
      },
      {
        "category": "fiction",
        "author": "J. R. R. Tolkien",
        "title": "The Lord of the Rings",
        "isbn": "0-395-19395-8",
        "price": 22.99
      }
    ],
    "bicycle": {
      "color": "red",
      "price": 19.95
    }
  }
}  
  ''');

  print('All prices in the store, by JSONPath:');
  JsonPath(r'$..price')
      .read(document)
      .map((match) => '${match.path}:\t${match.value}')
      .forEach(print);

  print('\nSame, by JSON Pointer:');
  JsonPath(r'$..price')
      .read(document)
      .map((match) => '${match.pointer}:\t${match.value}')
      .forEach(print);

  print('\nSame, but just the values:');
  JsonPath(r'$..price').readValues(document).forEach(print);

  print('\nBooks under 10:');
  JsonPath(r'$.store.book[?@.price < 10].title')
      .readValues(document)
      .forEach(print);

  print('\nBooks with ISBN:');
  JsonPath(r'$.store.book[?@.isbn].title').readValues(document).forEach(print);

  print('\nBooks under 10 with ISBN:');
  JsonPath(r'$.store.book[?@.price < 10 && @.isbn].title')
      .readValues(document)
      .forEach(print);

  print('\nBooks with "the" in the title:');
  JsonPath(r'$.store.book[?search(@.title, "the")].title')
      .readValues(document)
      .forEach(print);

  print('\nBooks with the same category as the last one:');
  JsonPath(r'$.store.book[?@.category == $.store.book[-1].category].title')
      .readValues(document)
      .forEach(print);
}
