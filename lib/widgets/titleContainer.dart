import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/size_config.dart';

Container buildTitle(BuildContext context, String title) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: rWidth(20), vertical: rWidth(30)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            margin: EdgeInsets.only(left: rWidth(10)),
            child: Text(title,
                style: TextStyle(
                    fontFamily: "Kamerik-Bold", fontSize: rWidth(25)))),
      ],
    ),
  );
}
