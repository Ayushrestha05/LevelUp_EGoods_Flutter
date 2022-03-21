import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:levelup_egoods/utilities/constants.dart';

class GiftCard with ChangeNotifier {
  int _id = 0, _totalReviews = 0;
  String _itemName = '', _itemDescription = '', _itemImage = '', _option = '';
  var _cardDetails = [];
  var _latestReview = [];
  int _isSelected = 0;
  double _averageRating = 0;

  get id => _id;
  get itemName => _itemName;
  get itemDescription => _itemDescription;
  get itemImage => _itemImage;
  get isSelected => _isSelected;
  get option => _option;
  get cardDetails => _cardDetails;
  get totalReviews => _totalReviews;
  get averageRating => _averageRating;
  get latestReview => _latestReview;

  GiftCard(int itemID) {
    _id = itemID;
    getCardDetails();
    getReviewData();
  }

  void getCardDetails() async {
    var response = await http.get(Uri.parse('$apiUrl/items/gift-card-data/$id'),
        headers: {'Accept': 'application/json'});

    var decode = jsonDecode(response.body)[0];
    _itemName = decode['item_details']['item_name'];
    _itemDescription = decode['item_details']['item_description'];
    _itemImage = decode['item_details']['item_image'];
    _cardDetails = decode['gift_card_details'];
    _isSelected = _cardDetails[0]['id'];
    _option = _cardDetails[0]['card_type'];
    notifyListeners();
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

  void setSelected(int id) {
    _isSelected = id;
    getSelectedPrice();
    notifyListeners();
  }

  String getSelectedPrice() {
    for (int i = 0; i < _cardDetails.length; i++) {
      if (_cardDetails[i]['id'] == _isSelected) {
        _option = _cardDetails[i]['card_type'];
        return _cardDetails[i]['card_price'].toString();
      }
    }

    return 'NaN';
  }
}
