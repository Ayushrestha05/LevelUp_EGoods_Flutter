import 'dart:convert';

import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/items/item_screen_switch.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:levelup_egoods/widgets/connection-issues.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchTextField = TextEditingController();
  int _filterCategory = 8;
  bool _sortAsc = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
          child: buildEndDrawer(),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: rWidth(15)),
          padding: EdgeInsets.only(
            top: rWidth(20),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Hero(
                      tag: 'searchbar',
                      child: Material(
                        child: TextFormField(
                          controller: _searchTextField,
                          enabled: true,
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                              hintText: 'Search Items',
                              hintStyle:
                                  TextStyle(fontFamily: 'Archivo-Regular'),
                              prefixIcon: Icon(
                                AntIcons.searchOutlined,
                              ),
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: rWidth(15),
                  ),
                  IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                      icon: Icon(Icons.menu))
                ],
              ),
              SizedBox(
                height: rWidth(15),
              ),
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  margin: EdgeInsets.symmetric(horizontal: rWidth(5)),
                  child: FutureBuilder(
                    future: search(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return buildNoConnectionError();

                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());

                        case ConnectionState.done:
                          var decode = jsonDecode(snapshot.data ?? '');
                          if (snapshot.hasData && decode.length > 0) {
                            return GridView.builder(
                                clipBehavior: Clip.none,
                                itemCount: decode.length,
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
                                        categoryID: decode[index]
                                            ['category_id'],
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
                                                margin:
                                                    EdgeInsets.all(rWidth(5)),
                                                child: Hero(
                                                  tag:
                                                      'itemImage${decode[index]['id']}',
                                                  child: CachedNetworkImage(
                                                    httpHeaders: const {
                                                      'Connection':
                                                          'Keep-Alive',
                                                      'Keep-Alive':
                                                          'timeout=10,max=1000'
                                                    },
                                                    imageUrl: decode[index]
                                                        ['item_image'],
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      height: rWidth(145),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
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
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'assets/images/placeholder/Image_Placeholder.jpg'))),
                                                      );
                                                    },
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      height: rWidth(170),
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
                                                      overflow: TextOverflow
                                                          .ellipsis),
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
                            return buildNoDataError(text: 'No Results Found.');
                          }

                        default:
                          return buildDefaultError();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> search() async {
    var response = await http.post(Uri.parse('$apiUrl/search'), headers: {
      'Accept': 'application/json'
    }, body: {
      'search': '${_searchTextField.text}',
      'filter': '$_filterCategory',
      'sort_name': _sortAsc ? 'ASC' : 'DESC',
    });
    print(response.body);
    return response.body;
  }

  Widget? buildEndDrawer() {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: rWidth(10), vertical: rWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by Category',
            style: TextStyle(fontFamily: 'Archivo', fontSize: rWidth(18)),
          ),
          SizedBox(
            height: rWidth(20),
          ),
          FutureBuilder(
              future: getCategories(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Text('No Connection');

                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());

                  case ConnectionState.done:
                    var decode = jsonDecode(snapshot.data ?? '');
                    return DropdownButtonFormField(
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        value: _filterCategory,
                        items: List.generate(
                            decode.length,
                            (index) => DropdownMenuItem(
                                  child: Text(decode[index]['category_name']),
                                  value: decode[index]['id'],
                                )),
                        onChanged: (value) {
                          var test = '$value';
                          _filterCategory = int.parse(test);
                          setState(() {});
                        });
                  default:
                    return Text('Error');
                }
              }),
          SizedBox(
            height: rWidth(20),
          ),
          Row(
            children: [
              Text(
                'Sort by Name',
                style: TextStyle(fontFamily: 'Archivo', fontSize: rWidth(18)),
              ),
              Spacer(),
              _sortAsc
                  ? IconButton(
                      onPressed: () {
                        _sortAsc = false;
                        setState(() {});
                      },
                      icon: Icon(Icons.arrow_circle_up_rounded))
                  : IconButton(
                      onPressed: () {
                        _sortAsc = true;
                        setState(() {});
                      },
                      icon: Icon(Icons.arrow_circle_down_rounded))
            ],
          ),
        ],
      ),
    );
  }

  Future<String>? getCategories() async {
    final response = await http.get(Uri.parse('$apiUrl/categories'));
    return response.body;
  }
}
