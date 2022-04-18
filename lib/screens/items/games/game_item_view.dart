import 'dart:io';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:alert/alert.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:levelup_egoods/screens/imageView/image_view.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/models/game.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/bottomNavigationItemBar.dart';
import 'package:levelup_egoods/widgets/buildCustomerReviews.dart';
import 'package:levelup_egoods/widgets/wishlistButton.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class GameView extends StatelessWidget {
  final String imageURL;
  const GameView({Key? key, required this.imageURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final gameData = Provider.of<Game>(context);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: gameData.gamePrices.length != 0
            ? buildBottomNavigationBarItem(gameData.getSelectedPrice(), () {
                auth.addToCart(context, gameData.id, gameData.option);
              })
            : Container(
                color: const Color(0xFF112149),
                padding: EdgeInsets.symmetric(
                    horizontal: rWidth(10), vertical: rWidth(10)),
                child: Text(
                  "Releasing ${DateFormat('dd MMMM, yyyy').format(gameData.releaseDate)}",
                  style: TextStyle(
                      fontFamily: 'Outfit',
                      color: Colors.white,
                      fontSize: rWidth(25)),
                ),
              ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: rWidth(250),
                child: Swiper(
                  //fade: 0.5,
                  autoplay: gameData.gameImages.length == 1 ? false : true,
                  autoplayDelay: 7000,
                  //viewportFraction: rWidth(0.5),
                  //scale: rWidth(0.5),
                  itemCount: gameData.gameImages.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                        httpHeaders: const {
                          'Connection': 'Keep-Alive',
                          'Keep-Alive': 'timeout=10,max=1000'
                        },
                        imageUrl: gameData.gameImages[index],
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: rWidth(14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: rWidth(10),
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: rWidth(280),
                              child: Text(
                                gameData.itemName,
                                style: TextStyle(
                                    fontFamily: 'Outfit', fontSize: rWidth(20)),
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
                                  rating: gameData.averageRating,
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
                                    "${gameData.averageRating} (${gameData.totalReviews})",
                                    style: TextStyle(
                                        fontFamily: 'Gotham',
                                        fontSize: rWidth(10)),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Spacer(),
                        WishlistButton(
                          itemID: gameData.id,
                          ctx: context,
                        )
                      ],
                    ),
                    SizedBox(
                      height: rWidth(10),
                    ),
                    gameData.gamePrices.length != 0
                        ? Text('Available For:')
                        : Container(),
                    gameData.gamePrices.length != 0
                        ? SizedBox(
                            height: rWidth(5),
                          )
                        : Container(),
                    gameData.gamePrices.length != 0
                        ? Container(
                            height: rWidth(40),
                            child: ListView.builder(
                                itemCount: gameData.gamePrices.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (builder, index) {
                                  return Container(
                                    margin: EdgeInsets.only(right: rWidth(5)),
                                    child: gameData.selected ==
                                            gameData.gamePrices[index]['id']
                                        ? ChoiceChip(
                                            padding: EdgeInsets.only(
                                                left: rWidth(5)),
                                            avatar: SvgPicture.network(
                                              gameData.gamePrices[index]
                                                  ['platform_logo'],
                                              height: rWidth(20),
                                              width: rWidth(20),
                                            ),
                                            selected: true,
                                            label: Text(
                                                gameData.gamePrices[index]
                                                    ['platform_name']),
                                            onSelected: (value) {
                                              gameData.setSelected(gameData
                                                  .gamePrices[index]['id']);
                                            })
                                        : ChoiceChip(
                                            padding: EdgeInsets.only(
                                                left: rWidth(5)),
                                            avatar: SvgPicture.network(
                                              gameData.gamePrices[index]
                                                  ['platform_logo'],
                                              height: rWidth(20),
                                              width: rWidth(20),
                                            ),
                                            selected: false,
                                            label: Text(
                                                gameData.gamePrices[index]
                                                    ['platform_name']),
                                            onSelected: (value) {
                                              gameData.setSelected(gameData
                                                  .gamePrices[index]['id']);
                                            }),
                                  );
                                }),
                          )
                        : Container(),
                    SizedBox(
                      height: rWidth(20),
                    ),
                    Text(
                      gameData.description,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Archivo-Regular',
                        fontSize: rWidth(12),
                        color: const Color(0xFF686868),
                      ),
                    ),
                    SizedBox(
                      height: rWidth(20),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red)),
                      onPressed: () {
                        _launchURL(gameData.trailer);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(AntIcons.youtubeFilled),
                          SizedBox(
                            width: rWidth(10),
                          ),
                          const Text('Watch Trailer')
                        ],
                      ),
                    ),
                    SizedBox(
                      height: rWidth(20),
                    ),
                    buildCustomerReviews(
                        data: gameData.latestReview, context: context),
                    SizedBox(
                      height: rWidth(20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _launchURL(String link) async {
    if (Platform.isIOS) {
      if (await canLaunch("youtube://" + link)) {
        await launch("youtube://" + link);
      } else {
        if (await canLaunch(link)) {
          await launch(link, forceSafariVC: true);
        } else {
          Alert(message: 'Could not launch link').show();
        }
      }
    } else {
      if (await canLaunch(link)) {
        await launch(link);
      } else {
        Alert(message: 'Could not launch link').show();
      }
    }
  }
}
