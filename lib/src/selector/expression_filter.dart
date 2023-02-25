import 'package:json_path/src/node.dart';
import 'package:json_path/src/node_mapper.dart';
import 'package:json_path/src/selector/wildcard.dart';

class ExpressionFilter extends Wildcard {
  ExpressionFilter(this.filter);

  final NodeMapper<bool> filter;

  @override
  Iterable<Node> apply(Node match) => super.apply(match).where(filter);
}
