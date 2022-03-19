import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:levelup_egoods/screens/items/item_screen_switch.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/size_config.dart';

class ItemGrid extends StatefulWidget {
  final int categoryID;

  const ItemGrid({Key? key, required this.categoryID}) : super(key: key);

  @override
  _ItemGridState createState() => _ItemGridState();
}

class _ItemGridState extends State<ItemGrid> {
  Future<String>? getItems() async {
    var response = await http
        .get(Uri.parse('$apiUrl/items/category/${widget.categoryID}'));
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(),
        child: Scaffold(
          body: Container(
            clipBehavior: Clip.none,
            decoration: const BoxDecoration(),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: FutureBuilder(
              future: getItems(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Text('No Connection');

                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());

                  case ConnectionState.done:
                    var decode = jsonDecode(snapshot.data ?? '');
                    if (snapshot.hasData && decode.length > 0) {
                      return GridView.builder(
                          clipBehavior: Clip.none,
                          itemCount: decode.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.8,
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
                                  heroTag: 'itemImage${decode[index]['id']}',
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                      boxShadow: getBoxShadow(context),
                                      color: Theme.of(context)
                                                  .scaffoldBackgroundColor
                                                  .value ==
                                              4292929004
                                          ? Colors.white
                                          : Color(0xFF2E2E2E),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(5),
                                          child: Hero(
                                            tag:
                                                'itemImage${decode[index]['id']}',
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
                                                // height: 100,
                                                // width: 100,
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) {
                                                if (error != null) {
                                                  print(error);
                                                }
                                                return const Icon(Icons.error);
                                              },
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                height: 170,
                                                // width: 100,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: imageProvider)),
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
                                                fontSize: rWidth(16),
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
                          });
                    } else {
                      return Text('No Data Found');
                    }

                  default:
                    return Text('Error');
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
