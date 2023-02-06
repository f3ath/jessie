import 'package:json_path/src/selector/callback_filter.dart';
import 'package:petitparser/parser.dart';

final _callbackName =
    (char('_') | letter()) & (char('_') | letter() | digit()).star();

final callback =
    _callbackName.flatten().skip(before: char('?')).map(CallbackFilter.new);
