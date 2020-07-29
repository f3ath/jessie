# [JSONPath] for Dart
Jessie is a work-in-progress. Expect the API to change often. Feel free to join.

## Roadmap
- [x] Basic selectors: fields, indices
- [x] Recursive descent (`$..`)
- [x] Wildcard (`$.store.*`)
- [ ] Square-bracket field notation (`['foo']`, `$['"some" \'special\' [chars]']`)
- [ ] Subscript (`books[:2]`)
- [ ] Slice (`articles[1:10:2]`)
- [ ] Union (`book[0, 1]`, `book[author, title, price]`)
- [ ] Basic filtering (`book[?(@.price - 1)]`)
- [ ] Expressions?


[JSONPath]: https://goessner.net/articles/JsonPath/