import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/models/giftcard.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/bottomNavigationItemBar.dart';
import 'package:levelup_egoods/widgets/buildCustomerReviews.dart';
import 'package:levelup_egoods/widgets/wishlistButton.dart';
import 'package:provider/provider.dart';

class GiftCardView extends StatelessWidget {
  final String imageURL;
  final String heroTag;
  const GiftCardView({Key? key, required this.imageURL, required this.heroTag})
      : super(key: key);

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
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: rWidth(10), vertical: rWidth(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: heroTag,
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
                  height: rWidth(10),
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
                              ? ChoiceChip(
                                  label: Text(giftCardData.cardDetails[index]
                                      ['card_type']),
                                  selected: true,
                                  onSelected: (value) {
                                    giftCardData.setSelected(
                                        giftCardData.cardDetails[index]['id']);
                                  },
                                )
                              : ChoiceChip(
                                  label: Text(giftCardData.cardDetails[index]
                                      ['card_type']),
                                  selected: false,
                                  onSelected: (value) {
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
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: rWidth(280),
                          child: Text(
                            giftCardData.itemName,
                            style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: rWidth(20),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: rWidth(5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RatingBarIndicator(
                              rating: giftCardData.averageRating,
                              itemBuilder: (context, index) =>
                                  const Icon(Icons.star, color: Colors.amber),
                              itemCount: 5,
                              itemSize: 15,
                            ),
                            SizedBox(
                              width: rWidth(5),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: rWidth(2)),
                              child: Text(
                                "${giftCardData.averageRating} (${giftCardData.totalReviews})",
                                style: TextStyle(
                                    fontFamily: 'Gotham', fontSize: rWidth(10)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    WishlistButton(
                      itemID: giftCardData.id,
                      ctx: context,
                    ),
                  ],
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
                      fontSize: rWidth(14)),
                ),
                SizedBox(
                  height: rWidth(20),
                ),
                buildCustomerReviews(
                    data: giftCardData.latestReview, context: context),
                SizedBox(
                  height: rWidth(20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
