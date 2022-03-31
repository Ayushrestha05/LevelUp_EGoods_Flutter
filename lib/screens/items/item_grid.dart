import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:levelup_egoods/screens/items/item_screen_switch.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/size_config.dart';

class ItemGrid extends StatefulWidget {
  final int categoryID;
  final int index;
  final data;

  const ItemGrid(
      {Key? key,
      required this.categoryID,
      required this.data,
      required this.index})
      : super(key: key);

  @override
  _ItemGridState createState() => _ItemGridState();
}

class _ItemGridState extends State<ItemGrid> {
  int selectedIndex = 0;
  ScrollController scrollCtrl = ScrollController();
  var categoryItems = [];
  Future<String>? getItems() async {
    var response = await http.get(Uri.parse(
        '$apiUrl/items/category/${widget.data[selectedIndex]['id']}'));
    return response.body;
  }

  @override
  void initState() {
    selectedIndex = widget.index;
    getUnselectedCategoryItems();
    super.initState();
  }

  void getUnselectedCategoryItems() {
    var unselectedCategoryItems = [];
    for (int i = 0; i < widget.data.length; i++) {
      unselectedCategoryItems.add(widget.data[i]);
    }

    categoryItems = unselectedCategoryItems;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: rWidth(20),
                bottom: rWidth(20),
              ),
              height: 50,
              child: ListView(
                controller: scrollCtrl,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      right: rWidth(10),
                      left: rWidth(20),
                    ),
                    child: Text(
                      widget.data[selectedIndex]['category_name'],
                      style: TextStyle(
                          fontFamily: 'Kamerik-Bold', fontSize: rWidth(25)),
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: categoryItems.length,
                        itemBuilder: (context, index) {
                          return index != selectedIndex
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                      getUnselectedCategoryItems();
                                      scrollCtrl.animateTo(0,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeIn);
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                        right: rWidth(10), top: rWidth(5)),
                                    child: Text(
                                        categoryItems[index]['category_name'],
                                        style: TextStyle(
                                            fontFamily: 'Kamerik-Bold',
                                            fontSize: rWidth(20),
                                            color: Colors.grey)),
                                  ),
                                )
                              : Container();
                        }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                margin: EdgeInsets.symmetric(horizontal: rWidth(15)),
                child: FutureBuilder(
                  future: getItems(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
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
                                      heroTag:
                                          'itemImage${decode[index]['id']}',
                                    );
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                                    return const Icon(
                                                        Icons.error);
                                                  },
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    height: 170,
                                                    // width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
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
          ],
        ),
      ),
    );
  }
}
