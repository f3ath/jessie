import 'package:json_path/src/fun/built_in/count_fun.dart';
import 'package:json_path/src/fun/built_in/length_fun.dart';
import 'package:json_path/src/fun/built_in/match_fun.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/fun/search_fun.dart';

const builtInFunctions = <Fun>[
  LengthFun(),
  CountFun(),
  MatchFun(),
  SearchFun(),
];
