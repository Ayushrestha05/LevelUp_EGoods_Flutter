import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/models/giftcard.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/bottomNavigationItemBar.dart';
import 'package:provider/provider.dart';

class GiftCardView extends StatelessWidget {
  final String imageURL;
  const GiftCardView({Key? key, required this.imageURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final giftCardData = Provider.of<GiftCard>(context);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: buildBottomNavigationBarItem(
          giftCardData.getSelectedPrice(),
          () {
            auth.addToCart(context, giftCardData.id, giftCardData.option);
          },
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: rWidth(10), vertical: rWidth(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'itemImage${giftCardData.id}',
                child: CachedNetworkImage(
                  imageUrl: imageURL,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) {
                    if (error != null) {}
                    return const Icon(Icons.error);
                  },
                  imageBuilder: (context, imageProvider) => Container(
                    height: rWidth(170),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(rWidth(10)),
                        image: DecorationImage(
                            fit: BoxFit.cover, image: imageProvider)),
                  ),
                ),
              ),
              SizedBox(
                height: rWidth(20),
              ),
              Container(
                height: rWidth(40),
                child: ListView.builder(
                    itemCount: giftCardData.cardDetails.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (builder, index) {
                      return Container(
                        margin: EdgeInsets.only(right: rWidth(5)),
                        child: giftCardData.isSelected ==
                                giftCardData.cardDetails[index]['id']
                            ? ElevatedButton(
                                child: Text(giftCardData.cardDetails[index]
                                    ['card_type']),
                                onPressed: () {
                                  giftCardData.setSelected(
                                      giftCardData.cardDetails[index]['id']);
                                },
                              )
                            : OutlinedButton(
                                child: Text(giftCardData.cardDetails[index]
                                    ['card_type']),
                                onPressed: () {
                                  giftCardData.setSelected(
                                      giftCardData.cardDetails[index]['id']);
                                },
                              ),
                      );
                    }),
              ),
              SizedBox(
                height: rWidth(20),
              ),
              Text(
                giftCardData.itemName,
                style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: rWidth(20),
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: rWidth(20),
              ),
              Text(
                giftCardData.itemDescription,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontFamily: 'Archivo-Regular',
                    color: const Color(0xFF686868),
                    fontSize: rWidth(12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
