import 'dart:convert';

import 'package:json_path/json_path.dart';

void main() {
  final document = jsonDecode('''
{
  "Information": {
	  "CustomField": "Custom #1",
		"Codes": [
			{
				"Code": null,
				"Id": null,
				"SafeCode": "{\\"Type\\":1,\\"Data\\":\\"base64encodeddata\\"}"
			}
		]
	}
}
''');
  JsonPath(r'$.Information.Codes[*].SafeCode')
      .readValues(document)
      .forEach(print);
}
