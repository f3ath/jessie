# [JSONPath] for Dart

```dart
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
}
```

## Features and limitations
Generally, this library tries to mimic the [reference implementations], except for the filtering.
Evaluated filtering expressions like `$..book[?(@.price<10)]` are NOT yet supported. 
Instead, use the callback-kind of filters.
```dart
/// Select all elements with price under 20
final path = JsonPath(r'$.store..[?discounted]', filters: {
'discounted': (match) =>
    match.value is Map && match.value['price'] is num && match.value['price'] < 20
});
``` 

[JSONPath]: https://goessner.net/articles/JsonPath/
[reference implementations]: https://goessner.net/articles/JsonPath/index.html#e4