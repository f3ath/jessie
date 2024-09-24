import 'package:json_path/json_path.dart';

void main() {
  const e1 =
      r"$..store[?(@.type == 'electronics')].items[?(@.price > 100 && @.availability == 'in stock')].details[?(@.specs.screen.size >= 40 && search(@.specs.processor, 'Intel|AMD'))].reviews[*].comments[?(@.rating >= 4 && @.verified == true)].content[?(length(@) > 100)]";
  const e2 =
      r"$..book[0:10][?(match(@.author, '(J.K.|George R.R.) Martin') && @.price < 30 && @.published >= '2010-01-01')].summary[?(length(@) > 200)]";
  const e3 =
      r"$..store.bicycle[?(@.price > 50)].model[?match(@, '(Mountain|Road)')]";
  const e4 =
      r"$..orders[*][?(@.status == 'delivered' && value(@.items[0:5][?(@.price > 50 && match(@.category, '(Electronics|Books)'))].quantity) > 1)].tracking[*].history[?(@.location == 'Warehouse' && @.status == 'out for delivery')]";

  final start = DateTime.now();
  for (var i = 0; i < 50000; i++) {
    JsonPath(e1);
    JsonPath(e2);
    JsonPath(e3);
    JsonPath(e4);
  }
  final end = DateTime.now();
  print(
      'Duration: ${end.difference(start).inMilliseconds} ms');
}
