import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/size_config.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTitle(context),
          buildCategoryCards(
            onTap: () {
              print('Hello World');
            },
            categoryTitle: 'Gift Cards',
            categoryImage:
                'https://i.pinimg.com/originals/03/98/49/03984975f10f0c0afd69f8b095b42818.jpg',
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

class buildCategoryCards extends StatelessWidget {
  final Function() onTap;
  final String categoryImage;
  final String categoryTitle;
  const buildCategoryCards({
    Key? key,
    required this.onTap,
    required this.categoryImage,
    required this.categoryTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: rWidth(28)),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(rWidth(10)),
        ),
        onTap: onTap,
        child: Container(
          height: rWidth(150),
          width: rWidth(411),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(rWidth(10)),
            color: const Color(0xFF5E5E5E).withOpacity(0.6),
            image: DecorationImage(
              opacity: 0.4,
              fit: BoxFit.cover,
              image: NetworkImage(
                categoryImage,
              ),
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(left: rWidth(16), bottom: rWidth(18)),
            alignment: AlignmentDirectional.bottomStart,
            child: Text(
              categoryTitle,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Outfit',
                  fontSize: rWidth(20),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
