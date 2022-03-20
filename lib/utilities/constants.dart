import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String apiUrl = "http://172.16.5.106:8000/api";

getBoxShadow(BuildContext context) {
  return Theme.of(context).scaffoldBackgroundColor.value == 4292929004
      ? const [
          BoxShadow(
              color: Color(0xFFA3B1C6), offset: Offset(9, 9), blurRadius: 12),
          BoxShadow(
              color: Colors.white, offset: Offset(-9, -9), blurRadius: 12),
        ]
      : [
          BoxShadow(
              color: Colors.black.withOpacity(0.4),
              offset: const Offset(9, 9),
              blurRadius: 12),
          const BoxShadow(
              color: Color(0xB33A3A3A), offset: Offset(-9, -9), blurRadius: 12),
        ];
}
