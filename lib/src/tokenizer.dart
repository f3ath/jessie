List tokenize(String expression) {
  final tokens = <Token>[];
  var exp = expression;
  while (exp.isNotEmpty) {
    switch (exp[0]) {
      case r'$':
        tokens.add(const Root());
        exp = exp.substring(1);
        break;
      case '*':
        tokens.add(const Asterisk());
        exp = exp.substring(1);
        break;
      case '[':
        tokens.add(const LeftBracket());
        exp = exp.substring(1);
        break;
      case ']':
        tokens.add(const RightBracket());
        exp = exp.substring(1);
        break;
      case '.':
        if (exp.length > 1 && exp[1] == '.') {
          tokens.add(const DoublePeriod());
          exp = exp.substring(2);
        } else {
          tokens.add(const Period());
          exp = exp.substring(1);
        }
        break;
      default:
        if (exp.startsWith(_digit)) {
          final num = _allDigits.firstMatch(exp).group(0);
          tokens.add(Number(int.parse(num)));
          exp = exp.substring(num.length);
        } else if (exp.startsWith(_char)) {
          final text = _allAlphanumeric.firstMatch(exp).group(0);
          tokens.add(Name(text));
          exp = exp.substring(text.length);
        } else {
          throw 'Can not tokenize "$exp"';
        }
    }
  }
  return tokens;
}

final _char = RegExp(r'[a-zA-Z]');
final _allAlphanumeric = RegExp(r'[a-zA-Z][a-zA-Z0-9]+');
final _digit = RegExp(r'\d');
final _allDigits = RegExp(r'\d+');

abstract class Token {}

class Root implements Token {
  const Root();

  @override
  String toString() => r'$';
}

class Period implements Token {
  const Period();

  @override
  String toString() => '.';
}

class DoublePeriod implements Token {
  const DoublePeriod();

  @override
  String toString() => '..';
}

class Name implements Token {
  const Name(this.value);

  final String value;

  @override
  String toString() => value;
}

class Number implements Token {
  const Number(this.value);

  final int value;

  @override
  String toString() => value.toString();
}

class Asterisk implements Token {
  const Asterisk();

  @override
  String toString() => '*';
}

class LeftBracket implements Token {
  const LeftBracket();

  @override
  String toString() => '[';
}

class RightBracket implements Token {
  const RightBracket();

  @override
  String toString() => ']';
}

//class LeftParenthesis implements Token {
//  const LeftParenthesis();
//}
//
//class RightParenthesis implements Token {
//  const RightParenthesis();
//}
//
//class Colon implements Token {
//  const Colon();
//}
//
//class Comma implements Token {
//  const Comma();
//}
