import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/models/illustration.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/bottomNavigationItemBar.dart';
import 'package:levelup_egoods/widgets/buildCustomerReviews.dart';
import 'package:levelup_egoods/widgets/wishlistButton.dart';
import 'package:provider/provider.dart';

class IllustrationView extends StatelessWidget {
  final String imageURL;
  final String heroTag;
  const IllustrationView(
      {Key? key, required this.imageURL, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final illustration = Provider.of<Illustration>(context);
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: buildBottomNavigationBarItem(
        illustration.getSelectedPrice(),
        () {
          auth.addToCart(context, illustration.id, illustration.option);
        },
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: rWidth(10),
          vertical: rWidth(10),
        ),
        child: Column(
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
                      image: DecorationImage(
                          fit: BoxFit.contain, image: imageProvider)),
                ),
              ),
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
                        illustration.name,
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
                          rating: illustration.averageRating,
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
                            "${illustration.averageRating} (${illustration.totalReviews})",
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
                  itemID: illustration.id,
                  ctx: context,
                )
              ],
            ),
            SizedBox(
              height: rWidth(20),
            ),
            Text(
              'Sizes Available',
              style: TextStyle(fontSize: rWidth(13), fontFamily: 'Outfit'),
            ),
            SizedBox(
              height: rWidth(5),
            ),
            Container(
              height: rWidth(40),
              child: ListView.builder(
                itemCount: illustration.illustration_prices.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (builder, index) {
                  return Container(
                    margin: EdgeInsets.only(right: rWidth(5)),
                    child: illustration.selected ==
                            illustration.illustration_prices[index]['id']
                        ? ChoiceChip(
                            selected: true,
                            label: Text(illustration.illustration_prices[index]
                                ['size']),
                            onSelected: (value) {
                              illustration.setSelected(illustration
                                  .illustration_prices[index]['id']);
                            },
                          )
                        : ChoiceChip(
                            selected: false,
                            label: Text(illustration.illustration_prices[index]
                                ['size']),
                            onSelected: (value) {
                              illustration.setSelected(illustration
                                  .illustration_prices[index]['id']);
                            },
                          ),
                  );
                },
              ),
            ),
            SizedBox(
              height: rWidth(20),
            ),
            Text(
              illustration.description,
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
                data: illustration.latestReview, context: context),
            SizedBox(
              height: rWidth(20),
            ),
          ],
        ),
      ),
    ));
  }
}
