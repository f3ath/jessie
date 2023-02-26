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

  final prices = JsonPath(r'$..price');

  print('All prices in the store:');

  prices
      .read(document)
      .map((node) => '${node.pointer}:\t${node.value}')
      .forEach(print);

  print('Books under 10:');

  JsonPath(r'$.store.book[?(@.price < 10)].title')
      .read(document)
      .map((node) => '${node.pointer}:\t${node.value}')
      .forEach(print);
}
