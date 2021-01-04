## [Unreleased]
### Fixed
- `$[:]` throwing FormatException

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

[Unreleased]: https://github.com/f3ath/jessie/compare/0.2.0...HEAD
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