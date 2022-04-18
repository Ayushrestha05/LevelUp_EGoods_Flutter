import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utilities/size_config.dart';

Widget buildNoDataError({required String text}) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/svg_images/no-data.svg',
          height: rWidth(200),
          width: rWidth(200),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Gotham', fontSize: 15),
          ),
        ),
      ],
    ),
  );
}

Widget buildNoConnectionError() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/svg_images/no-connection.svg',
          height: rWidth(200),
          width: rWidth(200),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 50),
          child: const Text(
            'No Connection.',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Gotham', fontSize: 15),
          ),
        ),
      ],
    ),
  );
}

Widget buildDefaultError() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/svg_images/error.svg',
          height: rWidth(200),
          width: rWidth(200),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 50),
          child: const Text(
            'Some Error Occured. Please Try Again Later',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Gotham', fontSize: 15),
          ),
        ),
      ],
    ),
  );
}
