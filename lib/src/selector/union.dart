import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';

class ArrayUnion extends Selector {
  ArrayUnion(this.keys);

  final List<int> keys;
  @override
  Iterable<Result> call(Iterable<Result> results) {
    throw UnimplementedError();
  }

  @override
  String get expression => '[${keys.join(',')}]';
  
}