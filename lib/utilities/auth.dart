import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/user_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ChangeNotifier {
  bool _isAuthenticated = false;
  String _userName = 'User Name';
  String _userEmail = 'User Email';

  bool get isAuthenticated => _isAuthenticated;
  get userName => _userName;
  get userEmail => _userEmail;

  Auth() {
    getUserDetails();
  }

  void getUserDetails() async {
    String token = await UserHandler().getUserToken() ?? '';
    if (token != '') {
      final prefs = await SharedPreferences.getInstance();
      _userName = await prefs.getString('user_name') ?? 'User Name';
      _userEmail = await prefs.getString('user_email') ?? 'User Email';
      notifyListeners();
    }
  }

  Future<int> login(String? email, String? password) async {
    final response = await http.post(Uri.parse('$apiUrl/login'), body: {
      'email': email,
      'password': password,
    }, headers: {
      'Accept': 'application/json'
    });

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      UserHandler().saveLogin(jsonResponse['user']['name'],
          jsonResponse['user']['email'], jsonResponse['token']);
      _isAuthenticated = true;
      _userName = jsonResponse['user']['name'];
      _userEmail = jsonResponse['user']['email'];
      notifyListeners();
    }

    return response.statusCode;
  }

  Future<int> register(name, email, password) async {
    final response = await http.post(Uri.parse('$apiUrl/register'), body: {
      'name': name,
      'email': email,
      'password': password,
    }, headers: {
      'Accept': 'application/json'
    });

    if (response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      UserHandler().saveLogin(jsonResponse['user']['name'],
          jsonResponse['user']['email'], jsonResponse['token']);
      _isAuthenticated = true;
      _userName = jsonResponse['user']['name'];
      _userEmail = jsonResponse['user']['email'];
      notifyListeners();
    }

    return response.statusCode;
  }

  logout() async {
    final userToken = await UserHandler().getUserToken();
    final response = await http.post(Uri.parse('$apiUrl/logout'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken'
    });
    print(response.body);
    _isAuthenticated = false;
    UserHandler().loggedOut();
    notifyListeners();
  }
}
