import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/items/gift_card/giftcard_item_view.dart';
import 'package:levelup_egoods/utilities/models/giftcard.dart';
import 'package:provider/provider.dart';

class GiftCardProvider extends StatelessWidget {
  final int itemID;
  final String imageURL;
  const GiftCardProvider(
      {Key? key, required this.itemID, required this.imageURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GiftCard(itemID),
      child: GiftCardView(
        imageURL: imageURL,
      ),
    );
  }
}
