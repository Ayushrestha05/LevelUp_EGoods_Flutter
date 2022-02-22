import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:levelup_egoods/utilities/constants.dart';

class GiftCard with ChangeNotifier {
  int _id = 0;
  String _itemName = '', _itemDescription = '', _itemImage = '';

  get id => _id;
  get itemName => _itemName;
  get itemDescription => _itemDescription;
  get itemImage => _itemImage;

  GiftCard(int itemID) {
    _id = itemID;
  }

  void getCardDetails() async {
    var response = await http.get(Uri.parse('$apiUrl/items/music-data/$id'),
        headers: {'Accept': 'application/json'});

    var decode = jsonDecode(response.body);
    print(decode);
  }
}
