import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:levelup_egoods/screens/imageView/image_view.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/models/figurine.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/bottomNavigationItemBar.dart';
import 'package:levelup_egoods/widgets/buildCustomerReviews.dart';
import 'package:levelup_egoods/widgets/wishlistButton.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class FigurineView extends StatelessWidget {
  final String imageURL;
  const FigurineView({Key? key, required this.imageURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final figurineData = Provider.of<Figurine>(context);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar:
            buildBottomNavigationBarItem(figurineData.price.toString(), () {
          auth.addToCart(context, figurineData.id, null);
        }),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                ),
                height: rWidth(250),
                child: Swiper(
                  fade: 0.5,
                  autoplay: true,
                  autoplayDelay: 7000,
                  viewportFraction: rWidth(0.5),
                  scale: rWidth(0.5),
                  itemCount: figurineData.imagesList.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                        httpHeaders: const {
                          'Connection': 'Keep-Alive',
                          'Keep-Alive': 'timeout=10,max=1000'
                        },
                        imageUrl: figurineData.imagesList[index],
                        imageBuilder: (context, image) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ImageView(image: image)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover, image: image),
                              ),
                            ),
                          );
                        },
                        placeholder: (context, url) => Container(
                              height: 100,
                              width: 100,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        errorWidget: (context, url, error) {
                          if (error != null) {
                            print(error);
                          }
                          return const Icon(Icons.error);
                        });
                  },
                ),
              ),
              SizedBox(
                height: rWidth(20),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: rWidth(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      figurineData.itemName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: rWidth(16),
                      ),
                    ),
                    SizedBox(
                      height: rWidth(10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            figurineData.figurineHeight != ''
                                ? Text(
                                    'Height: ${figurineData.figurineHeight}',
                                    style: const TextStyle(
                                      fontFamily: 'Outfit',
                                    ),
                                  )
                                : Container(),
                            figurineData.figurineDimension != ''
                                ? Text(
                                    'Dimensions: ${figurineData.figurineDimension}',
                                    style: const TextStyle(
                                      fontFamily: 'Outfit',
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: rWidth(5),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RatingBarIndicator(
                                  rating: figurineData.averageRating,
                                  itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber),
                                  itemCount: 5,
                                  itemSize: 15,
                                ),
                                SizedBox(
                                  width: rWidth(5),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: rWidth(2)),
                                  child: Text(
                                    "${figurineData.averageRating} (${figurineData.totalReviews})",
                                    style: TextStyle(
                                        fontFamily: 'Gotham',
                                        fontSize: rWidth(10)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        WishlistButton(
                          itemID: figurineData.id,
                          ctx: context,
                        )
                      ],
                    ),
                    SizedBox(
                      height: rWidth(20),
                    ),
                    Text(
                      figurineData.description,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Archivo-Regular',
                        fontSize: rWidth(14),
                        color: const Color(0xFF686868),
                      ),
                    ),
                    SizedBox(
                      height: rWidth(10),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: buildCustomerReviews(
                          context: context, data: figurineData.latestReview),
                    ),
                    SizedBox(
                      height: rWidth(10),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
