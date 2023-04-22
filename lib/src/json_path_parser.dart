import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/expression/nodes.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/fun/fun_factory.dart';
import 'package:json_path/src/fun/standard/count.dart';
import 'package:json_path/src/fun/standard/length.dart';
import 'package:json_path/src/fun/standard/match.dart';
import 'package:json_path/src/fun/standard/search.dart';
import 'package:json_path/src/fun/standard/value.dart';
import 'package:json_path/src/grammar/json_path.dart';
import 'package:json_path/src/json_path.dart';
import 'package:json_path/src/json_path_internal.dart';
import 'package:petitparser/petitparser.dart';

/// A customizable JSONPath parser.
class JsonPathParser {
  /// Creates an instance of the parser.
  factory JsonPathParser({Iterable<Fun> functions = const []}) =>
      functions.isEmpty ? _standard : JsonPathParser._(functions);

  JsonPathParser._(Iterable<Fun> functions)
      : _parser =
            JsonPathGrammarDefinition(FunFactory([..._stdFun, ...functions]))
                .build<Expression<Nodes>>();

  /// The standard instance is pre-cached to speed up parsing when only
  /// the standard built-in functions are used.
  static final _standard = JsonPathParser._(_stdFun);

  /// Standard functions
  static const _stdFun = <Fun>[
    Count(),
    Length(),
    Match(),
    Search(),
    Value(),
  ];

  final Parser<Expression<Nodes>> _parser;

  /// Parses the JSONPath from s string [expression].
  /// Returns an instance of [JsonPath] or throws a [FormatException].
  JsonPath parse(String expression) =>
      JsonPathInternal(expression, _parser.parse(expression).value.call);
}
