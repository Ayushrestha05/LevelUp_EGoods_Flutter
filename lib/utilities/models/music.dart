import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:levelup_egoods/utilities/constants.dart';

class Music with ChangeNotifier {
  int _id = 0;
  double _digitalPrice = 0, _physicalPrice = 0, _selectedPrice = 0;
  String _albumName = '', _albumArtist = '', _albumImage = '', _albumType = '';
  var _albumTracks = [];
  String _isSelected = '';

  get id => _id;
  get albumName => _albumName;
  get albumArtist => _albumArtist;
  get albumImage => _albumImage;
  get albumType => _albumType;
  get digitalPrice => _digitalPrice;
  get physicalPrice => _physicalPrice;
  get albumTracks => _albumTracks;
  get isSelected => _isSelected;
  get selectedPrice => _selectedPrice;

  void getAlbumDetails() async {
    var response = await http.get(Uri.parse('$apiUrl/items/music-data/$id'),
        headers: {'Accept': 'application/json'});

    var decode = jsonDecode(response.body)[0];

    _albumName = decode['item_details']['item_name'];
    _albumArtist = decode['item_details']['item_description'];
    _albumImage = decode['item_details']['item_image'];
    _albumType = decode['album_details']['album_type'];
    _digitalPrice = decode['album_details']['digital_price'].toDouble();
    _physicalPrice = decode['album_details']['physical_price'].toDouble();
    _albumTracks = decode['album_tracks'];

    if (_digitalPrice == 0) {
      _isSelected = 'physical';
    } else {
      _isSelected = 'digital';
    }

    getValue(_isSelected);
    notifyListeners();
  }

  void setSelectedValue(String type) {
    _isSelected = type;
    getValue(_isSelected);
    notifyListeners();
  }

  void getValue(String type) {
    _isSelected = type;
    if (_isSelected == 'physical') {
      _selectedPrice = physicalPrice;
    } else {
      _selectedPrice = _digitalPrice;
    }
    notifyListeners();
  }

  Music(int itemID) {
    _id = itemID;
    getAlbumDetails();
  }
}
