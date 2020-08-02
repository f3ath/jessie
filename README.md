# [JSONPath] for Dart
**Warning!** This is a work-in-progress. Expect the API to change often. Also, feel free to join.

## Roadmap
- [x] Basic selectors: fields, indices
- [x] Recursive descent (`$..`)
- [x] Wildcard (`$.store.*`)
- [x] Square-bracket field notation (`['foo']`, `$['"some" \'special\' [chars]']`)
- [x] Slice (`articles[1:10:2]`)
- [x] Union (`book[0, 1]`, `book[author, title, price]`)
- [ ] Basic filtering (`book[?(@.price)]`)
- [ ] Expressions (`book[?(@.price * @.discount < 10)]`)


[JSONPath]: https://goessner.net/articles/JsonPath/