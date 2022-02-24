import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/size_config.dart';

Container buildBottomNavigationBarItem(
    String itemPrice, Function()? onPressed) {
  return Container(
    color: const Color(0xFF112149),
    padding: EdgeInsets.symmetric(horizontal: rWidth(10), vertical: rWidth(10)),
    child: Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'NPR',
              style: TextStyle(fontFamily: 'Righteous', color: Colors.white),
            ),
            Text(
              itemPrice,
              style: TextStyle(
                  fontFamily: 'Righteous',
                  color: Colors.white,
                  fontSize: rWidth(25)),
            )
          ],
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: rWidth(15), vertical: rWidth(10)),
            child: Icon(
              Icons.add_shopping_cart,
              color: Colors.black,
              size: rWidth(25),
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              const Color(0xFF6FFFE9),
            ),
          ),
        )
      ],
    ),
  );
}
