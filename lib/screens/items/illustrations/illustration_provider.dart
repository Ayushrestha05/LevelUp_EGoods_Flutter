import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/items/illustrations/illustration_item_view.dart';
import 'package:levelup_egoods/utilities/models/illustration.dart';
import 'package:provider/provider.dart';

class IllustrationProvider extends StatelessWidget {
  final int itemID;
  final String imageURL;
  final String heroTag;
  const IllustrationProvider(
      {Key? key,
      required this.itemID,
      required this.imageURL,
      required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Illustration(itemID),
      child: IllustrationView(imageURL: imageURL, heroTag: heroTag),
    );
  }
}
