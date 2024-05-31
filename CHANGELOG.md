# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.7.2] - 2024-05-30
### Added
- New functions: `key()` and `index()`

## [0.7.1] - 2024-03-02
### Changed
- Bumped the CTS to the latest

## [0.7.0] - 2023-12-29
### Changed
- Renamed `Nodes` to `NodeList`
- Bumped the CTS to the latest version

## [0.6.6] - 2023-09-23
### Fixed
- Logical expressions should be allowed in function arguments

## [0.6.5] - 2023-09-11
### Fixed
- Certain numbers were not parsed correctly

## [0.6.4] - 2023-08-26
### Changed
- Bump dependencies versions

## [0.6.3] - 2023-08-26
### Fixed
- Allow whitespaces after `?` in expressions

## [0.6.2] - 2023-07-21
### Fixed
- Disallow comparison of non-singular queries

## [0.6.1] - 2023-07-17
### Fixed
- Allow whitespace in between selector segments

## [0.6.0] - 2023-05-27
### Changed
- Bump SDK version to 3.0.0
- Disallow whitespace between the function name and the parentheses
- Disallow whitespace between the expression and the brackets
- `search()` and `match()` now strictly follow the I-Regexp convention. Expressions not conforming to I-Regexp will yield `false` regardless of the value

## [0.5.3] - 2023-04-29 \[YANKED\]
### Changed
- `search()` and `match()` now strictly follow the I-Regexp convention. Expressions not conforming to I-Regexp will yield `false` regardless of the value

## [0.5.2] - 2023-04-05
### Added
- Improved IRegex support

## [0.5.1] - 2023-03-28
### Added
- Better support for Normalized Paths

## [0.5.0] - 2023-03-23
### Added
- Full support of some built-in functions: `length()`, `size()`, `search()`, `match()`, `value()`.
- Basic support of custom user-defined functions.

### Changed
- BC-BREAKING! The package is now following the [IETF JSON Path spec](https://www.ietf.org/archive/id/draft-ietf-jsonpath-base-10.html)
which means a lot of internal and BC-breaking changes. Please refer to the tests and examples.

### Removed
- BC-BREAKING! Support of the callback filters has been dropped. Use custom functions instead.

## [0.4.4] - 2023-03-18
### Fixed
- Reverted changes from 0.4.3 as they caused dependency issues.

## [0.4.3] - 2023-03-18
### Fixed
- Deprecation warnings from petitparser.

## [0.4.2] - 2022-08-03
### Added
- Expressions enhancements: float literals, negation, parenthesis.

## [0.4.1] - 2022-06-14
### Added
- Lower case hex support

### Changed
- Updated CTS to latest

## [0.4.0] - 2022-03-21
### Changed
- Dart 2.16
- Dependency bump: petitparser 5.0.0

## [0.3.1] - 2021-12-18
### Added
- Filtering expressions

### Changed
- Require dart 2.15

## [0.3.0] - 2021-02-18
### Added
- `JsonPathMatch.context` contains the matching context. It is intended to be used in named filters.
- `JsonPathMatch.parent` contains the parent match.
- `JsonPathMatch.pointer` contains the RFC 6901 JSON Pointer to the match.
- Very basic support for evaluated expressions

### Changed
- Named filters argument renamed from `filter` to `filters`
- Named filters can now be passed to the `read()` method.
- Named filters callback now accepts the entire `JsonPathMatch` object, not just the value.

### Removed
- The `set()` method. Use the `pointer` property instead.

## [0.2.0] - 2020-09-07
### Added
- Ability to create arrays and set adjacent indices

### Changed
- List union sorts the keys

### Fixed
- Improved union parsing stability

## [0.1.2] - 2020-09-06
### Changed
- When JsonPath.set() is called on a path with non-existing property, the property will be created.
Previously, no modification would be made and no errors/exceptions thrown.
- When JsonPath.set() is called on a path with non-existing index, a `RangeError` will be thrown.
Previously, no modification would be made and no errors/exceptions thrown.

## [0.1.1] - 2020-09-05
### Fixed
- Fixed example code in the readme

## [0.1.0] - 2020-09-05
### Added
- JsonPath.set() method to alter the JSON object in a non-destructive way

### Changed
- **BREAKING!** `Result` renamed to `JsonPathMatch`
- **BREAKING!**  `JsonPath.filter()` renamed to `read()`

## [0.0.2] - 2020-09-01
### Fixed
- Last element of array would not get selected (regression #1)

## [0.0.1] - 2020-08-03
### Added
- Filters

## [0.0.0+dev.7] - 2020-08-02
### Changed
- Tokenized and AST refactoring

## [0.0.0+dev.6] - 2020-08-01
### Added
- Unions

## [0.0.0+dev.5] - 2020-07-31
### Added
- Slice expression

## [0.0.0+dev.4] - 2020-07-29
### Added
- Bracket field notation support

## [0.0.0+dev.3] - 2020-07-28
### Added
- Partial implementation of bracket field notation

## [0.0.0+dev.2] - 2020-07-28
### Added
- Recursive selector
- Wildcard selector

## [0.0.0+dev.1] - 2020-07-27
### Added
- Tokenizer and AST
- All-in-array selector

## 0.0.0+dev.0 - 2020-07-24
### Added
- Basic design draft

[0.7.2]: https://github.com/f3ath/jessie/compare/0.7.1...0.7.2
[0.7.1]: https://github.com/f3ath/jessie/compare/0.7.0...0.7.1
[0.7.0]: https://github.com/f3ath/jessie/compare/0.6.6...0.7.0
[0.6.6]: https://github.com/f3ath/jessie/compare/0.6.5...0.6.6
[0.6.5]: https://github.com/f3ath/jessie/compare/0.6.4...0.6.5
[0.6.4]: https://github.com/f3ath/jessie/compare/0.6.3...0.6.4
[0.6.3]: https://github.com/f3ath/jessie/compare/0.6.2...0.6.3
[0.6.2]: https://github.com/f3ath/jessie/compare/0.6.1...0.6.2
[0.6.1]: https://github.com/f3ath/jessie/compare/0.6.0...0.6.1
[0.6.0]: https://github.com/f3ath/jessie/compare/0.5.3...0.6.0
[0.5.3]: https://github.com/f3ath/jessie/compare/0.5.2...0.5.3
[0.5.2]: https://github.com/f3ath/jessie/compare/0.5.1...0.5.2
[0.5.1]: https://github.com/f3ath/jessie/compare/0.5.0...0.5.1
[0.5.0]: https://github.com/f3ath/jessie/compare/0.4.4...0.5.0
[0.4.4]: https://github.com/f3ath/jessie/compare/0.4.3...0.4.4
[0.4.3]: https://github.com/f3ath/jessie/compare/0.4.2...0.4.3
[0.4.2]: https://github.com/f3ath/jessie/compare/0.4.1...0.4.2
[0.4.1]: https://github.com/f3ath/jessie/compare/0.4.0...0.4.1
[0.4.0]: https://github.com/f3ath/jessie/compare/0.3.1...0.4.0
[0.3.1]: https://github.com/f3ath/jessie/compare/0.3.0...0.3.1
[0.3.0]: https://github.com/f3ath/jessie/compare/0.2.0...0.3.0
[0.2.0]: https://github.com/f3ath/jessie/compare/0.1.2...0.2.0
[0.1.2]: https://github.com/f3ath/jessie/compare/0.1.1...0.1.2
[0.1.1]: https://github.com/f3ath/jessie/compare/0.1.0...0.1.1
[0.1.0]: https://github.com/f3ath/jessie/compare/0.0.2...0.1.0
[0.0.2]: https://github.com/f3ath/jessie/compare/0.0.1...0.0.2
[0.0.1]: https://github.com/f3ath/jessie/compare/0.0.0+dev.7...0.0.1
[0.0.0+dev.7]: https://github.com/f3ath/jessie/compare/0.0.0+dev.6...0.0.0+dev.7
[0.0.0+dev.6]: https://github.com/f3ath/jessie/compare/0.0.0+dev.5...0.0.0+dev.6
[0.0.0+dev.5]: https://github.com/f3ath/jessie/compare/0.0.0+dev.4...0.0.0+dev.5
[0.0.0+dev.4]: https://github.com/f3ath/jessie/compare/0.0.0+dev.3...0.0.0+dev.4
[0.0.0+dev.3]: https://github.com/f3ath/jessie/compare/0.0.0+dev.2...0.0.0+dev.3
[0.0.0+dev.2]: https://github.com/f3ath/jessie/compare/0.0.0+dev.1...0.0.0+dev.2
[0.0.0+dev.1]: https://github.com/f3ath/jessie/compare/0.0.0+dev.0...0.0.0+dev.1
