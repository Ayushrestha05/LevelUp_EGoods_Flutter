import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/items/music/music_item_view.dart';
import 'package:levelup_egoods/utilities/models/music.dart';
import 'package:provider/provider.dart';

class MusicProvider extends StatelessWidget {
  final int itemID;
  final String imageURL;
  final String heroTag;
  const MusicProvider(
      {Key? key,
      required this.itemID,
      required this.imageURL,
      required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Music(itemID),
      child: MusicViewScreen(
        imageURL: imageURL,
        heroTag: heroTag,
      ),
    );
  }
}
