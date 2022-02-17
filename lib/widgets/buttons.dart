import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/size_config.dart';

//TODO Add a OnPressed Parameter
SizedBox DefaultButton(String buttonText, Function() onPressed) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: rWidth(10)),
        child: Text(
          buttonText,
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

GestureDetector buildBackButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
    },
    child: Container(
      padding: EdgeInsets.all(rWidth(7)),
      decoration: const BoxDecoration(
        color: Color(0xFFC4C4C4),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.chevron_left),
    ),
  );
}
