import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/notification_history/notification_history_screen.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/buttons.dart';
import 'package:levelup_egoods/widgets/clickableSearchBar.dart';
import 'package:http/http.dart' as http;
import 'package:levelup_egoods/widgets/connection-issues.dart';

import '../../utilities/constants.dart';
import '../items/item_screen_switch.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'))),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'LevelUp E-Goods',
                    style: TextStyle(
                        fontFamily: 'Archivo',
                        //fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => NotificationHistoryScreen()));
                      },
                      icon: Icon(Icons.notifications_outlined)),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              clickableSearchBar(context),
              const SizedBox(
                height: 20,
              ),
              buildAds(),
              const SizedBox(
                height: 20,
              ),
              buildUpcomingGames(),
              const SizedBox(
                height: 20,
              ),
              buildArtistItems(),
              SizedBox(
                height: rWidth(20),
              ),
              buildNewlyInItemGrid(),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<String> buildArtistItems() {
    return FutureBuilder(
        future: getArtist(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return buildNoConnectionError();

            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());

            case ConnectionState.done:
              var decode = jsonDecode(snapshot.data ?? '');
              return decode.length > 0
                  ? decode['illustrations'].length > 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 15),
                              child: Text(
                                'Artist Specials',
                                style: TextStyle(
                                    fontFamily: 'Kamerik-Bold',
                                    fontSize: rWidth(20)),
                              ),
                            ),
                            SizedBox(
                              height: rWidth(10),
                            ),
                            SizedBox(
                              height: 250,
                              child: Swiper(
                                autoplay:
                                    (decode['illustrations'].length ?? 1) == 1
                                        ? false
                                        : true,
                                autoplayDelay: 5000,
                                index: 1,
                                itemCount: decode['illustrations'].length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        CachedNetworkImage(
                                          httpHeaders: const {
                                            'Connection': 'Keep-Alive',
                                            'Keep-Alive': 'timeout=10,max=1000'
                                          },
                                          imageUrl: decode['illustrations']
                                              [index]['item_image'],
                                          placeholder: (context, url) =>
                                              Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 7),
                                            height: 170,
                                            decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                image: const DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        'assets/images/placeholder/Image_Placeholder.jpg')),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          errorWidget: (context, url, error) {
                                            if (error != null) {
                                              print(error);
                                            }
                                            return Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 7),
                                              height: 170,
                                              decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  image: const DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                          'assets/images/placeholder/Portrait_Placeholder.png')),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            );
                                          },
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  GestureDetector(
                                            onTap: () {
                                              itemScreen(
                                                  context: context,
                                                  categoryID:
                                                      decode['illustrations']
                                                              [index]
                                                          ['category_id'],
                                                  itemID:
                                                      decode['illustrations']
                                                          [index]['id'],
                                                  imageURL:
                                                      decode['illustrations']
                                                          [index]['item_image'],
                                                  heroTag:
                                                      decode['illustrations']
                                                              [index]['id']
                                                          .toString());
                                            },
                                            child: Hero(
                                              tag: decode['illustrations']
                                                      [index]['id']
                                                  .toString(),
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7),
                                                height: 170,
                                                decoration: BoxDecoration(
                                                    color: Colors.redAccent,
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: imageProvider),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Spacer(),
                                                  CachedNetworkImage(
                                                    httpHeaders: const {
                                                      'Connection':
                                                          'Keep-Alive',
                                                      'Keep-Alive':
                                                          'timeout=10,max=1000'
                                                    },
                                                    imageUrl: decode['artist']
                                                        ['profile_image'],
                                                    placeholder:
                                                        (context, url) =>
                                                            CircleAvatar(
                                                      radius: rWidth(10),
                                                      foregroundImage:
                                                          const AssetImage(
                                                              'assets/images/placeholder/Portrait_Placeholder.png'),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) {
                                                      if (error != null) {
                                                        print(error);
                                                      }
                                                      return CircleAvatar(
                                                        radius: rWidth(10),
                                                        foregroundImage:
                                                            const AssetImage(
                                                                'assets/images/placeholder/Portrait_Placeholder.png'),
                                                      );
                                                    },
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        CircleAvatar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      radius: rWidth(20),
                                                      foregroundImage:
                                                          imageProvider,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: Text(
                                                      decode['artist']['name'],
                                                      style: TextStyle(
                                                          fontFamily: 'Outfit',
                                                          fontSize: 20),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : Container()
                  : Container();
            default:
              return Text('Error');
          }
        });
  }

  FutureBuilder<String> buildUpcomingGames() {
    return FutureBuilder(
        future: getUpcomingGames(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return buildNoConnectionError();

            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());

            case ConnectionState.done:
              var decode = jsonDecode(snapshot.data ?? '');
              return decode.length > 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 15),
                          child: Text(
                            'Upcoming Games',
                            style: TextStyle(
                                fontFamily: 'Kamerik-Bold',
                                fontSize: rWidth(20)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 200,
                          child: Swiper(
                            //fade: 0.5,
                            autoplay: decode.length == 1 ? false : true,
                            autoplayDelay: 7000,
                            // viewportFraction: rWidth(0.5),
                            // scale: rWidth(0.5),
                            index: 1,
                            itemCount: decode.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  itemScreen(
                                    context: context,
                                    categoryID: decode[index]['category_id'],
                                    itemID: decode[index]['id'],
                                    imageURL: decode[index]['item_image'],
                                    heroTag: 'upcoming${decode[index]['id']}',
                                  );
                                },
                                child: Hero(
                                  tag: 'upcoming${decode[index]['id']}',
                                  child: CachedNetworkImage(
                                      httpHeaders: const {
                                        'Connection': 'Keep-Alive',
                                        'Keep-Alive': 'timeout=10,max=1000'
                                      },
                                      imageUrl: decode[index]['item_image'],
                                      imageBuilder: (context, image) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: rWidth(5)),
                                          height: 200,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: image),
                                              color: Colors.grey),
                                          child: Container(
                                            alignment: Alignment.bottomRight,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                      bottomRight:
                                                          Radius.circular(10),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    right: 0,
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 10),
                                                        child: Text(
                                                          'Upcoming ${decode[index]['release_date']}',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'Outfit',
                                                                  fontSize: 18),
                                                        )))
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      placeholder: (context, url) => Container(
                                            height: rWidth(100),
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/placeholder/Image_Placeholder.jpg'))),
                                          ),
                                      errorWidget: (context, url, error) {
                                        if (error != null) {
                                          print(error);
                                        }
                                        return Container(
                                          height: rWidth(100),
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/placeholder/Image_Placeholder.jpg'))),
                                        );
                                      }),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    )
                  : Container();
            default:
              return Text('Error');
          }
        });
  }

  FutureBuilder<String> buildAds() {
    return FutureBuilder(
        future: getAds(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return buildNoConnectionError();

            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());

            case ConnectionState.done:
              var decode = jsonDecode(snapshot.data ?? '');
              return decode.length > 0
                  ? Container(
                      height: 150,
                      child: Swiper(
                        autoplay: decode.length == 1 ? false : true,
                        autoplayDelay: 5000,
                        index: 1,
                        itemCount: decode.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Column(
                                      children: [
                                        Text(
                                          decode[index]['title'],
                                          style:
                                              TextStyle(fontFamily: 'Archivo'),
                                        ),
                                      ],
                                    ),
                                    content: SingleChildScrollView(
                                      child: Text(
                                        decode[index]['description'],
                                        style: TextStyle(
                                            fontFamily: 'Archivo-Regular'),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      DefaultButton('OK', () {
                                        Navigator.pop(context);
                                      })
                                    ],
                                  );
                                },
                              );
                            },
                            child: CachedNetworkImage(
                                httpHeaders: const {
                                  'Connection': 'Keep-Alive',
                                  'Keep-Alive': 'timeout=10,max=1000'
                                },
                                imageUrl: decode[index]['image_url'],
                                imageBuilder: (context, image) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: rWidth(5)),
                                    height: 200,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            fit: BoxFit.fitWidth, image: image),
                                        color: Colors.grey),
                                    child: Container(
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                placeholder: (context, url) => Container(
                                      height: rWidth(100),
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/placeholder/Image_Placeholder.jpg'))),
                                    ),
                                errorWidget: (context, url, error) {
                                  if (error != null) {
                                    print(error);
                                  }
                                  return Container(
                                    height: rWidth(100),
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/placeholder/Image_Placeholder.jpg'))),
                                  );
                                }),
                          );
                        },
                      ),
                    )
                  : Container();
            default:
              return Text('Error');
          }
        });
  }

  FutureBuilder<String> buildNewlyInItemGrid() {
    return FutureBuilder(
        future: getNewItems(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text('No Connection');

            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());

            case ConnectionState.done:
              var decode = jsonDecode(snapshot.data ?? '');
              return decode.length > 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 15),
                          child: Text(
                            'Newly In',
                            style: TextStyle(
                                fontFamily: 'Kamerik-Bold',
                                fontSize: rWidth(20)),
                          ),
                        ),
                        SizedBox(
                          height: rWidth(20),
                        ),
                        GridView.builder(
                            shrinkWrap: true,
                            clipBehavior: Clip.none,
                            itemCount: decode.length,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: rWidth(0.6),
                              crossAxisCount: 2,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  itemScreen(
                                    context: context,
                                    categoryID: decode[index]['category_id'],
                                    itemID: decode[index]['id'],
                                    imageURL: decode[index]['item_image'],
                                    heroTag: 'newly${decode[index]['id']}',
                                  );
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(rWidth(5)),
                                            child: Hero(
                                              tag:
                                                  'newly${decode[index]['id']}',
                                              child: CachedNetworkImage(
                                                httpHeaders: const {
                                                  'Connection': 'Keep-Alive',
                                                  'Keep-Alive':
                                                      'timeout=10,max=1000'
                                                },
                                                imageUrl: decode[index]
                                                    ['item_image'],
                                                placeholder: (context, url) =>
                                                    Container(
                                                  height: rWidth(145),
                                                  decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/images/placeholder/Image_Placeholder.jpg'))),
                                                ),
                                                errorWidget:
                                                    (context, url, error) {
                                                  if (error != null) {
                                                    print(error);
                                                  }
                                                  return Container(
                                                    height: rWidth(145),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: const BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/placeholder/Image_Placeholder.jpg'))),
                                                  );
                                                },
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  height: rWidth(170),
                                                  // width: 100,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image:
                                                              imageProvider)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: rWidth(5),
                                                right: rWidth(5),
                                                bottom: rWidth(8)),
                                            child: Text(
                                              decode[index]['item_name'],
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontFamily: 'Outfit',
                                                  fontSize: rWidth(14),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ],
                    )
                  : Container();
            default:
              return Text('Error');
          }
        });
  }

  Future<String>? getNewItems() async {
    final response =
        await http.get(Uri.parse('$apiUrl/get-new-items'), headers: {
      'Accept': 'application/json',
    });
    return response.body;
  }

  Future<String>? getUpcomingGames() async {
    final response =
        await http.get(Uri.parse('$apiUrl/get-upcoming-games'), headers: {
      'Accept': 'application/json',
    });
    return response.body;
  }

  Future<String>? getAds() async {
    final response = await http.get(Uri.parse('$apiUrl/get-ads'), headers: {
      'Accept': 'application/json',
    });
    return response.body;
  }

  Future<String>? getArtist() async {
    final response = await http.get(Uri.parse('$apiUrl/get-artist'), headers: {
      'Accept': 'application/json',
    });
    return response.body;
  }
}
