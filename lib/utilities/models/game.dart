import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:levelup_egoods/utilities/constants.dart';

class Game with ChangeNotifier {
  int _id = 0, _selected = 0;
  String _itemName = '', _description = '', _trailer = '', _option = '';
  var _gameImages = [];
  var _gamePrices = [];
  DateTime _releaseDate = DateTime.now();

  get id => _id;
  get itemName => _itemName;
  get description => _description;
  get trailer => _trailer;
  get gameImages => _gameImages;
  get gamePrices => _gamePrices;
  get selected => _selected;
  get option => _option;
  get releaseDate => _releaseDate;

  Game(int itemID) {
    _id = itemID;
    getGameDetails();
  }

  void getGameDetails() async {
    var response = await http.get(Uri.parse('$apiUrl/items/game-data/$id'),
        headers: {'Accept': 'application/json'});

    var decode = jsonDecode(response.body);
    _itemName = decode['item_details']['item_name'];
    _description = decode['item_details']['item_description'];
    _trailer = decode['game_description']['trailer_url'];
    _gameImages = decode['game_images'];
    _gamePrices = decode['game_prices'];
    var date = decode['game_description']['release_date'].split('-');
    _releaseDate =
        DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]));
    print(_releaseDate);
    if (_gamePrices.length != 0) {
      _selected = _gamePrices[0]['id'];
      _option = _gamePrices[0]['platform_name'];
    }
    notifyListeners();
  }

  void setSelected(int id) {
    _selected = id;
    getSelectedPrice();
    notifyListeners();
  }

  String getSelectedPrice() {
    for (int i = 0; i < _gamePrices.length; i++) {
      if (_gamePrices[i]['id'] == _selected) {
        _option = _gamePrices[i]['platform_name'];
        return _gamePrices[i]['price'].toString();
      }
    }

    return 'NaN';
  }
}
