import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/items/item_grid.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:http/http.dart' as http;

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
          _buildTitle(context),
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

                    decode.forEach((element) {
                      String color = '';
                      if (element['category_color'].toString() != '' &&
                          element['category_color'] != null) {
                        color = element['category_color'];
                      } else {
                        color = '#5e5e5e';
                      }
                      categoryList.add(
                        buildCategoryCards(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ItemGrid(categoryID: element['id'])));
                          },
                          categoryTitle: element['category_name'],
                          categoryImage: element['category_image'],
                          categoryColor: color,
                        ),
                      );
                    });
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

  Container _buildTitle(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: rWidth(20), vertical: rWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor.value == 4280361249
                  ? Colors.white
                  : Colors.black,
              height: 2,
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: rWidth(20)),
              child: Text('Categories',
                  style:
                      TextStyle(fontFamily: "Outfit", fontSize: rWidth(24)))),
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor.value == 4280361249
                  ? Colors.white
                  : Colors.black,
              height: 2,
            ),
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
                    color: Color(int.parse(
                        widget.categoryColor.replaceAll('#', '0xff'))),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4.0, // soften the shadow
                        spreadRadius: 1.0, //extend the shadow
                        offset: Offset(
                          3.0, // Move to right 10  horizontally
                          4.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ]),
                child: const Icon(Icons.error));
          },
          imageBuilder: (context, imageProvider) => Container(
            height: rWidth(150),
            width: rWidth(411),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(rWidth(10)),
              color:
                  Color(int.parse(widget.categoryColor.replaceAll('#', '0xff')))
                      .withOpacity(0.6),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4.0, // soften the shadow
                  spreadRadius: 1.0, //extend the shadow
                  offset: Offset(
                    3.0, // Move to right 10  horizontally
                    4.0, // Move to bottom 10 Vertically
                  ),
                )
              ],
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
