import 'package:http/http.dart' as http;
import 'package:levelup_egoods/utilities/constants.dart';

class Auth {
  void login(String? email, String? password) async {
    final response = await http.post(Uri.parse('$apiUrl/login'), body: {
      'email': email,
      'password': password,
    }, headers: {
      'Accept': 'application/json'
    });

    print(response.body);
  }

  void register(name, email, password) async {
    final response = await http.post(Uri.parse('$apiUrl/register'), body: {
      'name': name,
      'email': email,
      'password': password,
    }, headers: {
      'Accept': 'application/json'
    });

    print(response.body);
  }
}
