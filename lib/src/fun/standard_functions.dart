import 'package:json_path/src/fun/count_fun.dart';
import 'package:json_path/src/fun/fun.dart';
import 'package:json_path/src/fun/length_fun.dart';
import 'package:json_path/src/fun/match_fun.dart';
import 'package:json_path/src/fun/search_fun.dart';

const standardFunctions = <Fun>[
  LengthFun(),
  CountFun(),
  MatchFun(),
  SearchFun(),
];
