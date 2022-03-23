import 'dart:convert';

import 'package:alert/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:levelup_egoods/utilities/constants.dart';

class Wishlist extends ChangeNotifier {
  var auth;
  var _wishlistItems = [];

  get wishlistItems => _wishlistItems;

  Wishlist(var auth) {
    this.auth = auth;
    getWishlist();
    notifyListeners();
  }

  void getWishlist() async {
    var response = await http.get(Uri.parse('$apiUrl/get-wishlist'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${auth.userToken}'
    });

    var decode = jsonDecode(response.body);
    _wishlistItems = decode['wishlist'];
    notifyListeners();
  }

  void removeFromWishlist({required String itemID}) async {
    var response = await http.post(Uri.parse('$apiUrl/remove-wishlist'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${auth.userToken}'
        },
        body: {
          'item_id': itemID
        });

    var decode = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Alert(message: decode['message']).show();
      getWishlist();
      notifyListeners();
    } else {
      Alert(message: decode['message']).show();
    }
  }
}
