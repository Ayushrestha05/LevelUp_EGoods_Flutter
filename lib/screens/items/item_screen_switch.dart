import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/items/figurine/figurine_provider.dart';
import 'package:levelup_egoods/screens/items/games/game_provider.dart';
import 'package:levelup_egoods/screens/items/gift_card/giftcard_provider.dart';
import 'package:levelup_egoods/screens/items/illustrations/illustration_provider.dart';
import 'package:levelup_egoods/screens/items/music/music_provider.dart';

void itemScreen(
    {required BuildContext context,
    required int categoryID,
    required int itemID,
    required String imageURL,
    required String heroTag}) {
  switch (categoryID) {
    case 1:
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => GiftCardProvider(
                    itemID: itemID,
                    imageURL: imageURL,
                    heroTag: heroTag,
                  )));
      break;

    case 2:
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => IllustrationProvider(
                    itemID: itemID,
                    imageURL: imageURL,
                    heroTag: heroTag,
                  )));
      break;

    case 3:
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => FigurineProvider(
                    itemID: itemID,
                    imageURL: imageURL,
                    heroTag: heroTag,
                  )));
      break;
    case 4:
    case 5:
    case 6:
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => GameProvider(
                    itemID: itemID,
                    imageURL: imageURL,
                    heroTag: heroTag,
                  )));
      break;
    case 7:
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MusicProvider(
                    itemID: itemID,
                    imageURL: imageURL,
                    heroTag: heroTag,
                  )));
      break;
  }
}
