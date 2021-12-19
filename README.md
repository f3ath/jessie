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

## Limitations
This library is intended to match the [original implementations], although filtering expressions (like `$..book[?(@.price < 10)]`) 
support is limited and may not always produce the results that you expect. The reason is the
difference between the type systems of Dart and JavaScript/PHP. Dart is strictly typed and does not support `eval()`,
so the expressions have to be parsed and evaluated by the library itself. Implementing complex logic this way would
create a performance overhead which I prefer to avoid.

## Callback filters
If there is a real need for complex filtering, you may use Dart-native callbacks. The syntax, _which is of course my own
invention and has nothing to do with the "official" JSONPath_, is the following:
```dart
/// Selects all elements with price under 20
final path = JsonPath(r'$.store..[?discounted]', filters: {
'discounted': (match) =>
    match.value is Map && match.value['price'] is num && match.value['price'] < 20
});
``` 
The filtering callbacks may be passed to the `JSONPath` constructor or to the `.read()` method. The callback name
must be specified in the square brackets and prefixed by `?`. It also must be alphanumeric.

## Data manipulation
Each `JsonPathMatch` produced by the `.read()` method contains the `.pointer` property which is a valid [JSON Pointer]
and can be used to write/append/remove the referenced value. If you're looking for data manipulation only, 
take a look at this [JSON Pointer implementation].

## References
- [Standard development](https://github.com/ietf-wg-jsonpath/draft-ietf-jsonpath-base)
- [Feature comparison matrix](https://cburgmer.github.io/json-path-comparison/)

[JSONPath]: https://goessner.net/articles/JsonPath/
[JSON Pointer]: https://datatracker.ietf.org/doc/html/rfc6901
[JSON Pointer implementation]: https://pub.dev/packages/rfc_6901
[original implementations]: https://goessner.net/articles/JsonPath/index.html#e4