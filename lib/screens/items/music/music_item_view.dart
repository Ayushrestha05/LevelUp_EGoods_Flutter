import 'dart:convert';

import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/widgets/buttons.dart';
import 'package:http/http.dart' as http;

class MusicViewScreen extends StatefulWidget {
  dynamic itemData;
  MusicViewScreen({Key? key, this.itemData}) : super(key: key);

  @override
  State<MusicViewScreen> createState() => _MusicViewScreenState();
}

class _MusicViewScreenState extends State<MusicViewScreen> {
  Future<String>? getTrackList(int itemID) async {
    var response = await http.get(Uri.parse('$apiUrl/items/music/$itemID'),
        headers: {'Accept': 'application/json'});

    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 19, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildBackButton(context),
              Container(
                margin: EdgeInsets.symmetric(vertical: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'itemImage${widget.itemData['id']}',
                      child: CachedNetworkImage(
                        imageUrl: widget.itemData['item_image'],
                        placeholder: (context, url) => Container(
                          // height: 100,
                          // width: 100,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) {
                          if (error != null) {
                            print(error);
                          }
                          return const Icon(Icons.error);
                        },
                        imageBuilder: (context, imageProvider) => Container(
                          height: 170,
                          width: 170,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.cover, image: imageProvider)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.itemData['item_name'],
                              style:
                                  TextStyle(fontFamily: 'Gotham', fontSize: 24),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.itemData['item_description'],
                              style:
                                  TextStyle(fontFamily: 'Gotham', fontSize: 14),
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
                    style: TextStyle(fontFamily: 'Gotham', fontSize: 16),
                  ),
                  Spacer(),
                  Icon(AntIcons.clockCircleOutlined),
                  SizedBox(
                    width: 17,
                  ),
                ],
              ),
              const Divider(
                color: Colors.black,
                thickness: 1.5,
              ),
              Container(
                height: 200,
                child: FutureBuilder(
                    future: getTrackList(widget.itemData['id']),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Text('No Connection');

                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());

                        case ConnectionState.done:
                          var decode = jsonDecode(snapshot.data ?? '');
                          return ListView.builder(
                              itemCount: decode.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.play_circle_fill,
                                          size: 30,
                                        ),
                                        onPressed: () {
                                          print(decode[index]['track_file']);
                                        },
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        decode[index]['track_name'],
                                        style: TextStyle(
                                            fontFamily: 'Gotham', fontSize: 14),
                                      ),
                                      Spacer(),
                                      Text(
                                        decode[index]['track_time'],
                                        style: TextStyle(
                                            fontFamily: 'Gotham', fontSize: 14),
                                      ),
                                    ],
                                  ),
                                );
                              });

                        default:
                          return Text('Error');
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
