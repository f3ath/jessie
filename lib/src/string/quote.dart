import 'package:json_path/src/string/escape.dart';

/// Quotes a [string] using [quotationMark]
String quote(String string, {String quotationMark = "'"}) =>
    quotationMark +
    escape(string).replaceAll(quotationMark, r'\' + quotationMark) +
    quotationMark;
