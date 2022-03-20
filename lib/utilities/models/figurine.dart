import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:levelup_egoods/utilities/constants.dart';

class Figurine extends ChangeNotifier {
  int _id = 0, _totalReviews = 0;
  String _itemName = '',
      _figurineHeight = '',
      _description = '',
      _figurineDimension = '';
  double _price = 0, _averageRating = 0;
  var _imagesList = [];

  get id => _id;
  get itemName => _itemName;
  get figurineHeight => _figurineHeight;
  get price => _price;
  get description => _description;
  get imagesList => _imagesList;
  get figurineDimension => _figurineDimension;
  get totalReviews => _totalReviews;
  get averageRating => _averageRating;

  Figurine(int itemID) {
    _id = itemID;
    getFigurineDetails();
    getReviewData();
  }

  void getFigurineDetails() async {
    var response = await http.get(Uri.parse('$apiUrl/items/figurine-data/$id'),
        headers: {'Accept': 'application/json'});

    var decode = jsonDecode(response.body);
    _itemName = decode['item_details']['item_name'];
    _figurineHeight = decode['figurine_details']['figurine_height'] ?? '';
    _figurineDimension = decode['figurine_details']['figurine_dimension'] ?? '';
    _price = decode['figurine_details']['price'].toDouble();
    _description = decode['figurine_details']['description'] ?? '';
    _imagesList = decode['figurine_images'];

    notifyListeners();
  }

  void getReviewData() async {
    var response = await http.get(Uri.parse('$apiUrl/reviews/$id'),
        headers: {'Accept': 'application/json'});

    var reviewDecode = jsonDecode(response.body);
    _totalReviews = reviewDecode['total_reviews'];
    _averageRating = reviewDecode['average_rating'].toDouble();
    notifyListeners();
  }
}
