import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/items/music/music_player.dart';
import 'package:levelup_egoods/utilities/models/music.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/buttons.dart';
import 'package:provider/provider.dart';

class MusicViewScreen extends StatelessWidget {
  final String imageURL;
  MusicViewScreen({Key? key, required this.imageURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final musicData = Provider.of<Music>(context);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Row(
          children: [
            Spacer(),
            TextButton(
              onPressed: () {},
              child: Text('Add to Cart'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color(0xFF0000FF),
                  ),
                  textStyle: MaterialStateProperty.all(
                      TextStyle(color: Color(0xFFFFFFFF)))),
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: rWidth(19), vertical: rWidth(14)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildBackButton(context),
              Container(
                margin: EdgeInsets.symmetric(vertical: rWidth(25)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'itemImage${musicData.id}',
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
                        margin:
                            EdgeInsets.only(left: rWidth(15), top: rWidth(10)),
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
                                  fontFamily: 'Gotham', fontSize: rWidth(24)),
                            ),
                            SizedBox(
                              height: rWidth(10),
                            ),
                            Text(
                              musicData.albumArtist,
                              style: TextStyle(
                                  fontFamily: 'Gotham', fontSize: rWidth(14)),
                            )
                          ],
                        ),
                      ),
                    )
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
              SizedBox(
                height: 200,
                child: ListView.builder(
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
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
