# [JSONPath] in Dart
[![Pub Package](https://img.shields.io/pub/v/json_path.svg)](https://pub.dev/packages/json_path)
[![Build Status](https://github.com/f3ath/jessie/actions/workflows/dart.yml/badge.svg?branch=master)](https://github.com/f3ath/jessie/actions/workflows/dart.yml)
[![GitHub Issues](https://img.shields.io/github/issues/f3ath/jessie.svg)](https://github.com/f3ath/jessie/issues)
[![GitHub Forks](https://img.shields.io/github/forks/f3ath/jessie.svg)](https://github.com/f3ath/jessie/network)
[![GitHub Stars](https://img.shields.io/github/stars/f3ath/jessie.svg)](https://github.com/f3ath/jessie/stargazers)
[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/f3ath/jessie/master/LICENSE)

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
      .map((node) => '${node.path}:\t${node.value}')
      .forEach(print);
}
```

## Limitations
This library follows the [JsonPath] internet draft specification. Since the spec itself is 
an evolving document, this implementation may lag behind, and some features may not be implemented in-full.
Please refer to the tests (there are hundreds of them, including the [CTS]) to see what is supported.


## Data manipulation
Each `Node` produced by the `.read()` method contains the `.pointer` property which is a valid [JSON Pointer]
and can be used to alter the referenced value. If you only need to manipulate JSON data, 
check out my [JSON Pointer implementation].

## User-defined functions
The JSONPath parser may be extended by user-defined functions. The user-defined functions
take precedence over the built-in ones which are defined by the standard. The functions
are polymorphic: you may define functions with the same name, and the parser will pick the first
of them which fits the use case (the return type, the number and the type or arguments).

## References
- [Standard development](https://github.com/ietf-wg-jsonpath/draft-ietf-jsonpath-base)
- [Feature comparison matrix](https://cburgmer.github.io/json-path-comparison/)

[CTS]: https://github.com/jsonpath-standard/jsonpath-compliance-test-suite
[JSONPath]: https://datatracker.ietf.org/wg/jsonpath/documents/
[JSON Pointer]: https://datatracker.ietf.org/doc/html/rfc6901
[JSON Pointer implementation]: https://pub.dev/packages/rfc_6901
