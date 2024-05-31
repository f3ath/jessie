# RFC 9535 - [JSONPath]: Query Expressions for JSON in Dart
[![Pub Package](https://img.shields.io/pub/v/json_path.svg)](https://pub.dev/packages/json_path)
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
      .map((match) => '${match.path}:\t${match.value}')
      .forEach(print);
}
```

This library fully implements the RFC 9535 [JsonPath] specification. It also should pass the latest version
of the [Compliance Test Suite]. If you find a missing or incorrectly implemented feature, please open an issue.

## Data manipulation
Each `JsonPathMatch` produced by the `.read()` method contains the `.pointer` property which is a valid [JSON Pointer]
and can be used to alter the referenced value. If you only need to manipulate JSON data, 
check out my [JSON Pointer implementation].

## User-defined functions
The JSONPath parser may be extended with user-defined functions. The user-defined functions
take precedence over the built-in ones specified by the standard. Currently, only
functions of 1 and 2 arguments are supported. 

To create your own function:
1. Import `package:json_path/fun_sdk.dart`.
2. Create a class implementing either `Fun1` (1 argument) or `Fun2` (2 arguments).

To use it:
1. Create a new JsonPathParser with your function: `final parser = JsonPathParser(functions: [MyFunction()]);`
2. Use it to parse you expression: `final jsonPath = parser.parse(r'$[?my_function(@)]');`

For more details see the included example.

This package comes with some non-standard functions which you might find useful.
- `count(<NodeList>)` - returns the number of nodes selected by the argument
- `index(<SingularNodeList>)` - returns the index under which the array element is referenced by the parent array
- `key(<SingularNodeList>)` - returns the key under which the object element is referenced by the parent object
- `is_array(<Maybe>)` - returns true if the value is an array
- `is_boolean(<Maybe>)` - returns true if the value is a boolean
- `is_number(<Maybe>)` - returns true if the value is a number
- `is_object(<Maybe>)` - returns true if the value is an object
- `is_string(<Maybe>)` - returns true if the value is a string
- `reverse(<Maybe>)` - reverses the string
- `siblings(<NodeList>)` - returns the siblings for the nodes
- `xor(<bool>, <bool>)` - returns the XOR of two booleans arguments

To use them, import `package:json_path/fun_extra.dart` and supply them to the `JsonPath()` constructor:

```dart
final jsonPath = JsonPathParser(functions: [
  const Key(),
  const Reverse(),
]).parse(r'$[?key(@) == reverse(key(@))]');
```
## References
- [Standard development](https://github.com/ietf-wg-jsonpath/draft-ietf-jsonpath-base)
- [Feature comparison matrix](https://cburgmer.github.io/json-path-comparison/)

[Compliance Test Suite]: https://github.com/jsonpath-standard/jsonpath-compliance-test-suite
[JSONPath]: https://datatracker.ietf.org/doc/rfc9535/
[JSON Pointer]: https://datatracker.ietf.org/doc/html/rfc6901
[JSON Pointer implementation]: https://pub.dev/packages/rfc_6901
