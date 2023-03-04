import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/fun/standard_functions.dart';
import 'package:json_path/src/fun/types/nodes_expression.dart';
import 'package:json_path/src/parser/json_path.dart';
import 'package:petitparser/parser.dart';

Parser<NodesExpression> jsonPathParser(
        {Iterable<Fun> userFunctions = const []}) =>
    JsonPathGrammarDefinition(userFunctions.followedBy(standardFunctions))
        .build<NodesExpression>();
