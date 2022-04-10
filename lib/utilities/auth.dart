import 'dart:convert';
import 'package:alert/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:levelup_egoods/screens/login_screen.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/user_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isArtist = false;
  String _userName = 'User Name';
  String _userEmail = 'User Email';
  String _profileImage = '';
  var _cartItems = [];
  double _totalPrice = 0;
  String _userToken = '';
  int _userPoint = 0;

  bool get isAuthenticated => _isAuthenticated;
  bool get isArtist => _isArtist;
  get userName => _userName;
  get userEmail => _userEmail;
  get cartItems => _cartItems;
  get totalPrice => _totalPrice;
  get userToken => _userToken;
  get userPoint => _userPoint;
  get profileImage => _profileImage;

  Auth() {
    getUserDetails();
  }

  void getUserDetails() async {
    String token = await UserHandler().getUserToken() ?? '';
    if (token != '') {
      final prefs = await SharedPreferences.getInstance();
      _userName = await prefs.getString('user_name') ?? 'User Name';
      _userEmail = await prefs.getString('user_email') ?? 'User Email';
      _userToken = token;
      _isAuthenticated = true;
      getCart();
      getUserPoints();
      notifyListeners();
    }
  }

  void getUserPoints() async {
    final response = await http.get(Uri.parse('$apiUrl/get-user-points'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken'
        });

    var decode = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _userPoint = decode['points'];
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
      _userToken = jsonResponse['token'];
      _userPoint = jsonResponse['user']['points'] ?? 0;
      _isArtist = (jsonResponse['user']['is_artist'] ?? 0) == 1 ? true : false;
      _profileImage = jsonResponse['user']['profile_image'] ?? '';
      Alert(message: "You have been logged in").show();
      notifyListeners();
      getCart();
      print(jsonResponse['token']);
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
      _userToken = jsonResponse['token'];
      notifyListeners();
      getCart();
    }

    return response.statusCode;
  }

  logout() async {
    final userToken = await UserHandler().getUserToken();
    final response = await http.post(Uri.parse('$apiUrl/logout'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken'
    });
    if (response.statusCode == 200) {
      _isAuthenticated = false;
      UserHandler().loggedOut();
      _cartItems = [];
      Alert(message: 'You have been logged out').show();
      notifyListeners();
    } else {
      Alert(message: 'Some Error Occurred. Please try again later.').show();
    }
  }

  void addToCart(BuildContext context, itemID, option) async {
    if (!isAuthenticated) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('Auth Error'),
              content: Text('You must be logged in to add items to your cart.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => LoginScreen()));
                    },
                    child: Text('Login')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK')),
              ],
            );
          });
    } else {
      final userToken = await UserHandler().getUserToken();
      var response = await http.post(
        Uri.parse('$apiUrl/cart/add'),
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $userToken'
        },
        body: jsonEncode({'item_id': itemID.toString(), 'option': option}),
      );
      var decode = jsonDecode(response.body);
      getCart();
      Alert(message: decode['message']).show();
      notifyListeners();
    }
  }

  void getCart() async {
    var response = await http.get(Uri.parse('$apiUrl/cart/get'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken'
    });

    var decode = jsonDecode(response.body);
    _cartItems = decode['items'] ?? [];

    if (decode['total_price'] == null) {
      _totalPrice = 0;
    } else {
      _totalPrice = decode['total_price'].toDouble();
    }
    notifyListeners();
  }

  void removeItemFromCart(BuildContext context, int cart_item) async {
    var response = await http.post(Uri.parse('$apiUrl/cart/remove'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({'cart_item_id': cart_item}));

    if (response.statusCode == 200) {
      Alert(message: jsonDecode(response.body)['message']).show();
      getCart();
      notifyListeners();
    } else {
      Alert(message: jsonDecode(response.body)['message']).show();
      notifyListeners();
    }
  }

  void increaseItemQuantity(BuildContext context, int cart_item) async {
    var response = await http.post(Uri.parse('$apiUrl/cart/increase'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({'cart_item_id': cart_item}));

    if (response.statusCode == 200) {
      Alert(message: jsonDecode(response.body)['message']).show();
      getCart();
      notifyListeners();
    } else {
      Alert(message: jsonDecode(response.body)['message']).show();
      notifyListeners();
    }
  }

  ///Reduce the Quantity of Cart Item by 1
  void decreaseItemQuantity(BuildContext context, int cart_item) async {
    var response = await http.post(Uri.parse('$apiUrl/cart/decrease'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({'cart_item_id': cart_item}));

    if (response.statusCode == 200) {
      Alert(message: jsonDecode(response.body)['message']).show();
      getCart();
      notifyListeners();
    } else {
      Alert(message: jsonDecode(response.body)['message']).show();
      notifyListeners();
    }
  }
}
