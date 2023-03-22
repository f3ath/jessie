import 'package:json_path/fun_sdk.dart';

/// The standard `length()` function.
class Length implements Fun1<Maybe, Maybe> {
  const Length();

  @override
  final name = 'length';

  @override
  Maybe call(Maybe v) => v.map(_length);

  int _length(v) {
    if (v is String) return v.length;
    if (v is List) return v.length;
    if (v is Map) return v.length;
    throw ArgumentError('Invalid arg type: ${v.runtimeType}');
  }
}
