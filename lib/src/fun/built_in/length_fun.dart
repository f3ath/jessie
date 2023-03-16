import 'package:json_path/functions.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

class LengthFun implements Fun1<Maybe, Maybe> {
  const LengthFun();

  @override
  final name = 'length';

  @override
  Maybe apply(Maybe v) => v.map(_length);

  int _length(v) {
    if (v is String) return v.length;
    if (v is List) return v.length;
    if (v is Map) return v.length;
    throw FormatException('Invalid arg type: ${v.runtimeType}');
  }
}
