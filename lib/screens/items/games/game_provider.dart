import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/items/games/game_item_view.dart';
import 'package:levelup_egoods/utilities/models/game.dart';
import 'package:provider/provider.dart';

class GameProvider extends StatelessWidget {
  final int itemID;
  final String imageURL;
  final String heroTag;
  const GameProvider(
      {Key? key,
      required this.itemID,
      required this.imageURL,
      required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Game(itemID),
      child: GameView(
        imageURL: imageURL,
      ),
    );
  }
}
