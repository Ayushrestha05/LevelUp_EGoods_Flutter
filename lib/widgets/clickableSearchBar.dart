import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/search/search_screen.dart';

InkWell clickableSearchBar(BuildContext context) {
  return InkWell(
    splashFactory: NoSplash.splashFactory,
    enableFeedback: false,
    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => SearchScreen()));
    },
    child: Hero(
      tag: 'searchbar',
      child: Material(
        child: TextFormField(
          enabled: false,
          decoration: const InputDecoration(
              hintText: 'Search Items',
              hintStyle: TextStyle(fontFamily: 'Archivo-Regular'),
              prefixIcon: Icon(
                AntIcons.searchOutlined,
              ),
              border: OutlineInputBorder()),
        ),
      ),
    ),
  );
}
