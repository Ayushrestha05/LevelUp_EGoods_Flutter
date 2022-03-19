import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/items/figurine/figurine_item_view.dart';
import 'package:levelup_egoods/utilities/models/figurine.dart';
import 'package:provider/provider.dart';

class FigurineProvider extends StatelessWidget {
  final int itemID;
  final String imageURL;
  final String heroTag;
  const FigurineProvider(
      {Key? key,
      required this.itemID,
      required this.imageURL,
      required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Figurine(itemID),
      child: FigurineView(
        imageURL: imageURL,
      ),
    );
  }
}
