import 'dart:convert';

import 'package:json_path/json_path.dart';

void main() {
  final json = jsonDecode('''
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

  final prices = JsonPath(r'$..price');

  print('All prices in the store:');

  /// The following code will print:
  ///
  /// $['store']['book'][0]['price']:	8.95
  /// $['store']['book'][1]['price']:	12.99
  /// $['store']['book'][2]['price']:	8.99
  /// $['store']['book'][3]['price']:	22.99
  /// $['store']['bicycle']['price']:	19.95
  prices
      .read(json)
      .map((match) => '${match.path}:\t${match.value}')
      .forEach(print);

  print('\n');

  final bikeColor = JsonPath(r'$.store.bicycle.color');

  print('A copy of the store with repainted bike:');
  print(bikeColor.set(json, 'blue'));

  print('\n');

  print('Note, that the bike in the original store is still red:');
  bikeColor
      .read(json)
      .map((result) => '${result.path}:\t${result.value}')
      .forEach(print);

  print('\n');

  print('It is also possible to modify json in place '
      'as long as the matching value is an object or a list:');
  final someBooks = JsonPath(r'$.store.book[::2]');
  someBooks.read(json).forEach((match) {
    match.value['title'] = 'Banana';
  });
  print(json);
}
