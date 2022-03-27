import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/items/item_grid.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:levelup_egoods/widgets/titleContainer.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  Future<String>? getCategoryData() async {
    final response = await http.get(Uri.parse('$apiUrl/categories'),
        headers: {'Accept': 'application/json'});
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildTitle(context, 'Categories'),
          FutureBuilder(
            future: getCategoryData(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());

                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text('Error!');
                  } else {
                    var decode = jsonDecode(snapshot.data ?? '');
                    List<Widget> categoryList = [];

                    for (int i = 0; i < decode.length; i++) {
                      String color = '';
                      if (decode[i]['category_color'].toString() != '' &&
                          decode[i]['category_color'] != null) {
                        color = decode[i]['category_color'];
                      } else {
                        color = '#5e5e5e';
                      }
                      categoryList.add(
                        buildCategoryCards(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ItemGrid(
                                          index: i,
                                          data: decode,
                                          categoryID: decode[i]['id'],
                                        )));
                          },
                          categoryTitle: decode[i]['category_name'],
                          categoryImage: decode[i]['category_image'],
                          categoryColor: color,
                        ),
                      );
                    }

                    return Column(
                      children: categoryList,
                    );
                  }
                default:
                  return Text('default');
              }
            },
          ),
        ],
      ),
    );
  }
}

class buildCategoryCards extends StatefulWidget {
  final Function() onTap;
  final String categoryImage;
  final String categoryTitle;
  final String categoryColor;
  const buildCategoryCards(
      {Key? key,
      required this.onTap,
      required this.categoryImage,
      required this.categoryTitle,
      required this.categoryColor})
      : super(key: key);

  @override
  State<buildCategoryCards> createState() => _buildCategoryCardsState();
}

class _buildCategoryCardsState extends State<buildCategoryCards> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: rWidth(28), left: rWidth(28), right: rWidth(28)),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(rWidth(10)),
        ),
        onTap: widget.onTap,
        child: CachedNetworkImage(
          httpHeaders: const {
            'Connection': 'Keep-Alive',
            'Keep-Alive': 'timeout=10,max=1000'
          },
          imageUrl: widget.categoryImage,
          placeholder: (context, url) => Container(
              height: rWidth(150),
              width: rWidth(411),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(rWidth(10)),
                color: Color(
                        int.parse(widget.categoryColor.replaceAll('#', '0xff')))
                    .withOpacity(0.6),
              ),
              child: Container(
                  height: rWidth(150),
                  width: rWidth(411),
                  child: const Center(child: CircularProgressIndicator()))),
          errorWidget: (context, url, error) {
            if (error != null) {
              print(error);
            }
            return Container(
                height: rWidth(150),
                width: rWidth(411),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(rWidth(10)),
                  color: Color(
                      int.parse(widget.categoryColor.replaceAll('#', '0xff'))),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: rWidth(40)),
                        child: const Icon(Icons.error),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(left: rWidth(16), bottom: rWidth(18)),
                      alignment: AlignmentDirectional.bottomStart,
                      child: Text(
                        widget.categoryTitle,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Outfit',
                            fontSize: rWidth(20),
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ));
          },
          imageBuilder: (context, imageProvider) => Container(
            height: rWidth(150),
            width: rWidth(411),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(rWidth(10)),
              color:
                  Color(int.parse(widget.categoryColor.replaceAll('#', '0xff')))
                      .withOpacity(0.6),
              image: DecorationImage(
                opacity: 0.4,
                fit: BoxFit.cover,
                image: imageProvider,
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(left: rWidth(16), bottom: rWidth(18)),
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                widget.categoryTitle,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Outfit',
                    fontSize: rWidth(20),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
