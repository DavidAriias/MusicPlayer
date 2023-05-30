import 'package:apple_music/classes/login_class.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


Future<Response> lookingForUsers(String email, String pass) async{

  final url = Uri.parse('https://applemusicservice.azurewebsites.net/users/$email/$pass');

  final response = await http.get(url);

  return response;
}

Future<Response> modifyUsers(String email, String pass) async{
  final url = Uri.parse('https://applemusicservice.azurewebsites.net/users');

  final response =  await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: modifyUserToJson(
      ModifyUser(email: email, password: pass)
    )
  );

  return response;
}

Future<Response> createUser(String email, String password) async{
  final url = Uri.parse('https://applemusicservice.azurewebsites.net/users');

  final response = await http.post(
    url,
    headers:  {
      'Content-Type': 'application/json',
    },

    body: createUserToJson(
      CreateUser(email: email, password: password)
    )
  );

  return response; 
}