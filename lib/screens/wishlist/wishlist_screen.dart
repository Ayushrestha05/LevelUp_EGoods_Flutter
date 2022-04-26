import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/items/item_screen_switch.dart';
import 'package:levelup_egoods/utilities/models/wishlist.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/connection-issues.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wishlist = Provider.of<Wishlist>(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: rWidth(15),
                  right: rWidth(15),
                  top: rWidth(30),
                  bottom: rWidth(20)),
              child: Text(
                'Wishlist',
                style:
                    TextStyle(fontFamily: 'Kamerik-Bold', fontSize: rWidth(30)),
              ),
            ),
            wishlist.wishlistItems.length > 0
                ? Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: wishlist.wishlistItems.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(top: rWidth(10)),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: rWidth(10)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        itemScreen(
                                          context: context,
                                          categoryID: wishlist
                                              .wishlistItems[index]['category'],
                                          itemID: wishlist.wishlistItems[index]
                                              ['item_id'],
                                          imageURL:
                                              wishlist.wishlistItems[index]
                                                  ['item_image'],
                                          heroTag:
                                              'wishlistItem${wishlist.wishlistItems[index]['id']}',
                                        );
                                      },
                                      child: Hero(
                                        tag:
                                            'wishlistItem${wishlist.wishlistItems[index]['id']}',
                                        child: CachedNetworkImage(
                                          httpHeaders: const {
                                            'Connection': 'Keep-Alive',
                                            'Keep-Alive': 'timeout=10,max=1000'
                                          },
                                          imageUrl:
                                              wishlist.wishlistItems[index]
                                                  ['item_image'],
                                          placeholder: (context, url) =>
                                              Container(
                                                  width: rWidth(84),
                                                  height: rWidth(120),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            rWidth(5)),
                                                    color: Colors.grey,
                                                  ),
                                                  child: const Expanded(
                                                      child: Center(
                                                          child:
                                                              CircularProgressIndicator()))),
                                          errorWidget: (context, url, error) {
                                            if (error != null) {
                                              print(error);
                                            }
                                            return Container(
                                                width: rWidth(110),
                                                height: rWidth(120),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          rWidth(10)),
                                                  color: Colors.grey,
                                                ),
                                                child: const Expanded(
                                                    child: Center(
                                                        child: Icon(
                                                            Icons.error))));
                                          },
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: rWidth(110),
                                            height: rWidth(120),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      rWidth(10)),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: imageProvider,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: rWidth(10),
                                            right: rWidth(10)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: rWidth(80),
                                              child: Text(
                                                wishlist.wishlistItems[index]
                                                    ['item_name'],
                                                style: TextStyle(
                                                    fontFamily: 'Outfit',
                                                    fontSize: rWidth(15)),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerRight,
                                              child: IconButton(
                                                icon:
                                                    Icon(AntIcons.heartFilled),
                                                color: Colors.indigo,
                                                onPressed: () {
                                                  wishlist.removeFromWishlist(
                                                      itemID: wishlist
                                                          .wishlistItems[index]
                                                              ['item_id']
                                                          .toString());
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: rWidth(10),
                              ),
                              Divider(
                                thickness: 2,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                //: Expanded(child: buildNoDataError(text: 'No Items Found.'))\
                : Expanded(
                    child: buildDefaultError(),
                  )
          ],
        ),
      ),
    );
  }
}
