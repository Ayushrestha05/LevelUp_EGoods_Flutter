import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:http/http.dart' as http;

class Illustration extends ChangeNotifier {
  int _id = 0, _userID = 0, _selected = 0, _totalReviews = 0;
  double _averageRating = 0;
  String _name = '',
      _description = '',
      _userName = '',
      _creator = '',
      _option = '';
  var _illustration_prices = [];
  var _latestReview = [];

  get id => _id;
  get name => _name;
  get description => _description;
  get userID => _userID;
  get userName => _userName;
  get creator => _creator;
  get illustration_prices => _illustration_prices;
  get selected => _selected;
  get option => _option;
  get totalReviews => _totalReviews;
  get averageRating => _averageRating;
  get latestReview => _latestReview;

  Illustration(int itemID) {
    _id = itemID;
    getIllustrationData();
    getReviewData();
  }

  void getIllustrationData() async {
    var response = await http.get(
        Uri.parse('$apiUrl/items/illustration-data/$id'),
        headers: {'Accept': 'application/json'});

    var decode = jsonDecode(response.body);
    _name = decode['item_details']['item_name'];
    _description = decode['illustration_details']['illustration_description'];
    _userID = decode['illustration_details']['user_id'] ?? 0;
    _userName = decode['illustration_details']['user_name'] ?? '';
    _creator = decode['illustration_details']['creator'] ?? '';
    _illustration_prices = decode['illustration_prices'];
    _selected = _illustration_prices[0]['id'];
    _option = _illustration_prices[0]['size'];
    notifyListeners();
  }

  void setSelected(int id) {
    _selected = id;
    getSelectedPrice();
    notifyListeners();
  }

  String getSelectedPrice() {
    for (int i = 0; i < _illustration_prices.length; i++) {
      if (_illustration_prices[i]['id'] == _selected) {
        _option = _illustration_prices[i]['size'];
        return _illustration_prices[i]['price'].toString();
      }
    }

    return 'NaN';
  }

  void getReviewData() async {
    var response = await http.get(Uri.parse('$apiUrl/reviews/$id'),
        headers: {'Accept': 'application/json'});

    var reviewDecode = jsonDecode(response.body);
    _totalReviews = reviewDecode['total_reviews'];
    _averageRating = reviewDecode['average_rating'].toDouble();
    _latestReview = reviewDecode['latest_review'];
    notifyListeners();
  }
}
