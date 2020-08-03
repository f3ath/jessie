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

  /// The following code will print:
  ///
  /// $['store']['book'][0]['price']:	8.95
  /// $['store']['book'][1]['price']:	12.99
  /// $['store']['book'][2]['price']:	8.99
  /// $['store']['book'][3]['price']:	22.99
  /// $['store']['bicycle']['price']:	19.95
  JsonPath(r'$..price')
      .filter(json)
      .map((result) => '${result.path}:\t${result.value}')
      .forEach(print);
}

```

## Features and limitations
Generally, this library tries to mimic the [reference implementations], except for the filtering.
Evaluated expressions are not supported, use named filters instead (see below).
### Fields and indices
Both dot-notation (`$.store.book[0].title`) and bracket-notation (`$['store']['book'][2]['title']`) are supported.

- The dot-notation only recognizes alphanumeric fields starting with a letter. Use bracket-notation for general cases.
- The bracket-notation supports only single quotes.

### Wildcards
Wildcards (`*`) can be used for objects (`$.store.*`) and arrays (`$.store.book[*]`);

### Recursion
Use `..` to iterate all elements recursively. E.g. `$.store..price` matches all prices in the store.

### Array slice
Use `[start:end:step]` to filter arrays. Any index can be omitted E.g. `$.store.book[3::2]` selects all even books
starting from the 4th. Negative `start` and `end` are also supported.

### Unions
Array (`book[0,1]`) and object (`book[author,title,price]`) unions are supported. 
Object unions support the bracket-notation.

### Filtering
Due to the nature of Dart language, filtering expressions like `$..book[?(@.price<10)]` are NOT supported. 
Instead, use the callback-kind of filters.
```dart
/// Select all elements with price under 20
JsonPath(r'$.store..[?discounted]', filter: {
  'discounted': (e) => e is Map && e['price'] is num && e['price'] < 20
});
``` 

[JSONPath]: https://goessner.net/articles/JsonPath/
[reference implementations]: https://goessner.net/articles/JsonPath/index.html#e4