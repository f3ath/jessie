import 'package:json_path/src/expression/expression.dart';
import 'package:json_path/src/expression/nodes.dart';
import 'package:json_path/src/fun/fun_call.dart';
import 'package:json_path/src/fun/fun_factory.dart';
import 'package:json_path/src/grammar/array_index.dart';
import 'package:json_path/src/grammar/array_slice.dart';
import 'package:json_path/src/grammar/child_selector.dart';
import 'package:json_path/src/grammar/comparison_expression.dart';
import 'package:json_path/src/grammar/dot_name.dart';
import 'package:json_path/src/grammar/filter_selector.dart';
import 'package:json_path/src/grammar/fun_name.dart';
import 'package:json_path/src/grammar/literal.dart';
import 'package:json_path/src/grammar/negatable.dart';
import 'package:json_path/src/grammar/parser_ext.dart';
import 'package:json_path/src/grammar/select_all_recursively.dart';
import 'package:json_path/src/grammar/sequence_selector.dart';
import 'package:json_path/src/grammar/singular_segment_sequence.dart';
import 'package:json_path/src/grammar/strings.dart';
import 'package:json_path/src/grammar/union_selector.dart';
import 'package:json_path/src/grammar/wildcard.dart';
import 'package:json_path/src/selector.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:petitparser/petitparser.dart';

class JsonPathGrammarDefinition
    extends GrammarDefinition<Expression<NodeList>> {
  JsonPathGrammarDefinition(this._fun);

  final FunFactory _fun;

  @override
  Parser<Expression<NodeList>> start() => _absPath().end();

  Parser<Expression<NodeList>> _absPath() => _segmentSequence()
      .skip(before: char(r'$'))
      .map((expr) => Expression((node) => expr.call(node.root)));

  Parser<Expression<NodeList>> _segmentSequence() =>
      _segment().star().map(sequenceSelector).map(Expression.new);

  Parser<Selector> _segment() => [
        dotName,
        wildcard.skip(before: char('.')),
        ref0(_union),
        ref0(_recursion),
      ].toChoiceParser().trim();

  Parser<Selector> _union() =>
      _unionElement().toList().inBrackets().map(unionSelector);

  Parser<Selector> _recursion() => [
        wildcard,
        _union(),
        memberNameShorthand,
      ]
          .toChoiceParser()
          .skip(before: string('..'))
          .map((value) => sequenceSelector([selectAllRecursively, value]));

  Parser<Selector> _unionElement() => [
        arraySlice,
        arrayIndex,
        wildcard,
        quotedString.map(childSelector),
        _expressionFilter(),
      ].toChoiceParser().trim();

  Parser<Selector> _expressionFilter() =>
      _logicalExpr().skip(before: string('?').trim()).map(filterSelector);

  Parser<Expression<bool>> _logicalExpr() => _logicalOrSequence()
      .map((list) => list.reduce((a, b) => a.merge(b, (a, b) => a || b)));

  Parser<List<Expression<bool>>> _logicalOrSequence() =>
      _logicalAndExpr().toList(string('||'));

  Parser<Expression<bool>> _logicalAndExpr() => _logicalAndSequence()
      .map((list) => list.reduce((a, b) => a.merge(b, (a, b) => a && b)));

  Parser<List<Expression<bool>>> _logicalAndSequence() =>
      _basicExpr().toList(string('&&'));

  Parser<Expression<bool>> _basicExpr() => [
        ref0(_parenExpr),
        comparisonExpression(_comparable()),
        _testExpr(),
      ].toChoiceParser(
          failureJoiner: (a, b) =>
              Failure(a.buffer, a.position, 'Expression expected'));

  Parser<Expression<bool>> _parenExpr() => negatable(_logicalExpr().inParens());

  Parser<Expression<bool>> _testExpr() => negatable([
        _existenceTest(),
        _logicalFunExpr(),
      ].toChoiceParser());

  Parser<Expression<bool>> _existenceTest() =>
      _filterPath().map((value) => value.map((v) => v.asLogical));

  Parser<Expression<bool>> _logicalFunExpr() => _funCall(_fun.logical);

  Parser<T> _funCall<T>(T Function(FunCall) toFun) =>
      (funName & _funArgument().toList().inParens())
          .map((v) => FunCall(v[0], v[1]))
          .tryMap(toFun);

  Parser<Expression> _funArgument() => [
        literal,
        _singularFilterPath(),
        _filterPath(),
        ref0(_valueFunExpr),
        ref0(_logicalFunExpr),
        ref0(_nodesFunExpr),
        ref0(_logicalExpr),
      ].toChoiceParser().trim();

  Parser<Expression<SingularNodeList>> _singularFilterPath() => [
        ref0(_singularRelPath),
        ref0(_singularAbsPath),
      ].toChoiceParser();

  Parser<Expression<Maybe>> _valueFunExpr() => _funCall(_fun.value);

  Parser<Expression<NodeList>> _nodesFunExpr() => _funCall(_fun.nodes);

  Parser<Expression<Maybe>> _comparable() => [
        literal,
        _singularFilterPath().map((expr) => expr.map((v) => v.asValue)),
        _valueFunExpr(),
      ].toChoiceParser();

  Parser<Expression<NodeList>> _filterPath() => [
        ref0(_relPath),
        ref0(_absPath),
      ].toChoiceParser();

  Parser<Expression<SingularNodeList>> _singularAbsPath() =>
      singularSegmentSequence
          .skip(before: char(r'$'), after: _segment().not())
          .map((expr) => Expression((node) => expr.call(node.root)));

  Parser<Expression<NodeList>> _relPath() =>
      _segmentSequence().skip(before: char('@'));

  Parser<Expression<SingularNodeList>> _singularRelPath() =>
      singularSegmentSequence.skip(before: char('@'), after: _segment().not());
}
