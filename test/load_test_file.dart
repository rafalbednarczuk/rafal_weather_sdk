import 'dart:io';

Future<String> loadTestResource(String fileName) async {
  final file = File('test_resources/$fileName');
  return await file.readAsString();
}
