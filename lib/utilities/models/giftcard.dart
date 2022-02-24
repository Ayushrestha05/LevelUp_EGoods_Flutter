import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:levelup_egoods/utilities/constants.dart';

class GiftCard with ChangeNotifier {
  int _id = 0;
  String _itemName = '', _itemDescription = '', _itemImage = '';
  var _cardDetails = [];
  int _isSelected = 0;

  get id => _id;
  get itemName => _itemName;
  get itemDescription => _itemDescription;
  get itemImage => _itemImage;
  get isSelected => _isSelected;
  get cardDetails => _cardDetails;

  GiftCard(int itemID) {
    _id = itemID;
    getCardDetails();
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
    notifyListeners();
  }

  void setSelected(int id) {
    _isSelected = id;
    notifyListeners();
  }

  String getSelectedPrice() {
    for (int i = 0; i < _cardDetails.length; i++) {
      if (_cardDetails[i]['id'] == _isSelected) {
        return _cardDetails[i]['card_price'].toString();
      }
    }

    return 'NaN';
  }
}
