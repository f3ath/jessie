import 'package:petitparser/petitparser.dart';

final cmpOperator =
    ['==', '!=', '<=', '>=', '<', '>'].map(string).toChoiceParser().trim();
