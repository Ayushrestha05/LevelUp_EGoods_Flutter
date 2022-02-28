import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/size_config.dart';

Container buildTitle(BuildContext context, String title) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: rWidth(20), vertical: rWidth(20)),
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
            child: Text(title,
                style: TextStyle(fontFamily: "Outfit", fontSize: rWidth(24)))),
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
