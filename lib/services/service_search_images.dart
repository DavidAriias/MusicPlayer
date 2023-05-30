import 'dart:typed_data';
import 'package:http/http.dart' as http;

Future<Uint8List> dataListSearch() async{

  final url = Uri.parse('https://applemusicservice.azurewebsites.net/searchImages');

  final response = await http.get(url);

  
  return response.bodyBytes;
}