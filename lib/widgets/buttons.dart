import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/size_config.dart';

Container DefaultButton() {
  return Container(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: rWidth(10)),
        child: Text(
          "Sign In",
          style: TextStyle(fontFamily: "Outfit", fontSize: rWidth(16)),
        ),
      ),
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor:
              MaterialStateProperty.all<Color>(const Color(0xFF103388)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ))),
    ),
  );
}
