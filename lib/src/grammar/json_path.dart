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
  Parser<Expression<NodeList>> start() => ref0(_absPath).end();

  Parser<Selector> _unionElement() => [
        arraySlice,
        arrayIndex,
        wildcard,
        quotedString.map(childSelector),
        _expressionFilter()
      ].toChoiceParser().trim();

  Parser<SingularSelector> _singularUnionElement() => [
        arrayIndex,
        quotedString.map(childSelector),
      ].toChoiceParser().trim();

  Parser<Selector> _union() =>
      _unionElement().toList().inBrackets().map(unionSelector);

  Parser<SingularSelector> _singularUnion() =>
      _singularUnionElement().inBrackets();

  Parser<Selector> _recursion() => [
        wildcard,
        _union(),
        memberNameShorthand,
      ]
          .toChoiceParser()
          .skip(before: string('..'))
          .map((value) => sequenceSelector([selectAllRecursively, value]));

  Parser<Expression<bool>> _parenExpr() => negatable(_logicalExpr().inParens());

  Parser<Expression> _funArgument() => [
        literal,
        ref0(_singularFilterPath),
        ref0(_filterPath),
        ref0(_valueFunExpr),
        ref0(_logicalFunExpr),
        ref0(_nodesFunExpr),
        ref0(_logicalExpr),
      ].toChoiceParser().trim();

  Parser<T> _funCall<T>(T Function(FunCall) toFun) =>
      (funName & _funArgument().toList().inParens())
          .map((v) => FunCall(v[0], v[1]))
          .tryMap(toFun);

  Parser<Expression<Maybe>> _valueFunExpr() => _funCall(_fun.value);

  Parser<Expression<NodeList>> _nodesFunExpr() => _funCall(_fun.nodes);

  Parser<Expression<bool>> _logicalFunExpr() => _funCall(_fun.logical);

  Parser<Expression<Maybe>> _comparable() => [
        literal,
        _singularFilterPath().map((expr) => expr.map((v) => v.asValue)),
        _valueFunExpr(),
      ].toChoiceParser();

  Parser<Expression<bool>> _logicalExpr() => _logicalOrExpr();

  Parser<Expression<bool>> _logicalOrExpr() => _logicalOrSequence()
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

  Parser<Expression<NodeList>> _filterPath() => [
        ref0(_relPath),
        ref0(_absPath),
      ].toChoiceParser();

  Parser<Expression<SingularNodeList>> _singularFilterPath() => [
        ref0(_singularRelPath),
        ref0(_singularAbsPath),
      ].toChoiceParser();

  Parser<Expression<bool>> _existenceTest() =>
      ref0(_filterPath).map((value) => value.map((v) => v.asLogical));

  Parser<Expression<bool>> _testExpr() => negatable([
        _existenceTest(),
        _logicalFunExpr(),
      ].toChoiceParser());

  Parser<Selector> _expressionFilter() =>
      _logicalExpr().skip(before: string('?').trim()).map(filterSelector);

  Parser<Selector> _segment() => [
        dotName,
        wildcard.skip(before: char('.')),
        ref0(_union),
        ref0(_recursion),
      ].toChoiceParser().trim();

  Parser<SingularSelector> _singularSegment() => [
        dotName,
        ref0(_singularUnion),
      ].toChoiceParser().trim();

  Parser<Expression<NodeList>> _segmentSequence() =>
      _segment().star().map(sequenceSelector).map(Expression.new);

  Parser<Expression<SingularNodeList>> _singularSegmentSequence() =>
      _singularSegment()
          .star()
          .map(singularSequenceSelector)
          .map(Expression.new);

  Parser<Expression<NodeList>> _absPath() => _segmentSequence()
      .skip(before: char(r'$'))
      .map((expr) => Expression((node) => expr.call(node.root)));

  Parser<Expression<SingularNodeList>> _singularAbsPath() =>
      _singularSegmentSequence()
          .skip(before: char(r'$'), after: _segment().not())
          .map((expr) => Expression((node) => expr.call(node.root)));

  Parser<Expression<NodeList>> _relPath() =>
      _segmentSequence().skip(before: char('@'));

  Parser<Expression<SingularNodeList>> _singularRelPath() =>
      _singularSegmentSequence()
          .skip(before: char('@'), after: _segment().not());
}
