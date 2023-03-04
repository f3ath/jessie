import 'package:json_path/src/expression/nodes_expression.dart';
import 'package:json_path/src/fun/built_in/functions.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/parser/json_path.dart';
import 'package:petitparser/parser.dart';

Parser<NodesExpression> jsonPathParser(
        {Iterable<Fun> userFunctions = const []}) =>
    JsonPathGrammarDefinition(userFunctions.followedBy(builtInFunctions))
        .build<NodesExpression>();
