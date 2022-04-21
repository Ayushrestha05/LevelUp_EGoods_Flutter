import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/items/music/music_player.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/models/music.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/bottomNavigationItemBar.dart';
import 'package:levelup_egoods/widgets/buildCustomerReviews.dart';
import 'package:levelup_egoods/widgets/bulidRatingStars.dart';
import 'package:levelup_egoods/widgets/wishlistButton.dart';
import 'package:provider/provider.dart';

class MusicViewScreen extends StatelessWidget {
  final String imageURL;
  final String heroTag;
  const MusicViewScreen(
      {Key? key, required this.imageURL, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final musicData = Provider.of<Music>(context);
    final auth = Provider.of<Auth>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: buildBottomNavigationBarItem(
          musicData.selectedPrice.toString(),
          () {
            auth.addToCart(
              context,
              musicData.id,
              musicData.isSelected,
            );
          },
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: rWidth(19), vertical: rWidth(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: rWidth(25), bottom: rWidth(10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                            height: 170,
                            width: 170,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(rWidth(10)),
                                image: DecorationImage(
                                    fit: BoxFit.cover, image: imageProvider)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: rWidth(15), top: rWidth(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                musicData.albumType,
                                style: TextStyle(
                                    fontFamily: 'Gotham', fontSize: rWidth(12)),
                              ),
                              SizedBox(
                                height: rWidth(10),
                              ),
                              Text(
                                musicData.albumName,
                                style: TextStyle(
                                    fontFamily: 'Gotham', fontSize: rWidth(20)),
                              ),
                              SizedBox(
                                height: rWidth(10),
                              ),
                              Text(
                                musicData.albumArtist,
                                style: TextStyle(
                                    fontFamily: 'Gotham', fontSize: rWidth(14)),
                              ),
                              SizedBox(
                                height: rWidth(10),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  buildRatingStars(musicData.averageRating),
                                  SizedBox(
                                    width: rWidth(5),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: rWidth(2)),
                                    child: Text(
                                      "${musicData.averageRating} (${musicData.totalReviews})",
                                      style: TextStyle(
                                          fontFamily: 'Gotham',
                                          fontSize: rWidth(10)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: rWidth(10),
                              ),
                              Container(
                                alignment: Alignment.bottomRight,
                                child: WishlistButton(
                                  itemID: musicData.id,
                                  ctx: context,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: rWidth(10)),
                  child: Row(
                    children: [
                      musicData.digitalPrice != 0
                          ? musicData.isSelected == 'digital'
                              ? ChoiceChip(
                                  selected: true,
                                  label: Text('Digital'),
                                  onSelected: (value) {
                                    musicData.setSelectedValue('digital');
                                  },
                                )
                              : ChoiceChip(
                                  selected: false,
                                  label: Text('Digital'),
                                  onSelected: (value) {
                                    musicData.setSelectedValue('digital');
                                  },
                                )
                          : Container(),
                      SizedBox(
                        width: 10,
                      ),
                      musicData.physicalPrice != 0
                          ? musicData.isSelected == 'physical'
                              ? ChoiceChip(
                                  selected: true,
                                  label: Text('Physical'),
                                  onSelected: (value) {
                                    musicData.setSelectedValue('physical');
                                  },
                                )
                              : ChoiceChip(
                                  selected: false,
                                  label: Text('Physical'),
                                  onSelected: (value) {
                                    musicData.setSelectedValue('physical');
                                  },
                                )
                          : Container(),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Tracks',
                      style:
                          TextStyle(fontFamily: 'Gotham', fontSize: rWidth(14)),
                    ),
                    const Spacer(),
                    Icon(
                      AntIcons.clockCircleOutlined,
                      size: rWidth(24),
                    ),
                    SizedBox(
                      width: rWidth(17),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 1.5,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: musicData.albumTracks.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(right: rWidth(15)),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.play_circle_fill,
                              size: rWidth(30),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => MusicPlayer(
                                            trackName:
                                                musicData.albumTracks[index]
                                                    ['track_name'],
                                            url: musicData.albumTracks[index]
                                                ['track_file'],
                                            id: musicData.id,
                                            albumName: musicData.albumName,
                                            image: imageURL,
                                          )));
                            },
                          ),
                          SizedBox(
                            width: rWidth(10),
                          ),
                          Text(
                            musicData.albumTracks[index]['track_name'],
                            style: TextStyle(
                                fontFamily: 'Gotham', fontSize: rWidth(12)),
                          ),
                          const Spacer(),
                          Text(
                            musicData.albumTracks[index]['track_time'],
                            style: TextStyle(
                              fontFamily: 'Gotham',
                              fontSize: rWidth(14),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: rWidth(10),
                ),
                buildCustomerReviews(
                    data: musicData.latestReview, context: context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
