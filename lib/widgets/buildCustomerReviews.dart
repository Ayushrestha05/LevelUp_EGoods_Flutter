import 'package:card_swiper/card_swiper.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/buttons.dart';

import 'bulidRatingStars.dart';

buildCustomerReviews({required var data, required BuildContext context}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Customer Reviews',
        style: TextStyle(fontFamily: 'Outfit', fontSize: rWidth(12)),
      ),
      data.length != 0
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: rWidth(7),
                ),
                ExpandablePageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: rWidth(20), vertical: rWidth(15)),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(data[index]['user_name']),
                                const Spacer(),
                                buildRatingStars(
                                    data[index]['rating'].toDouble())
                              ],
                            ),
                            SizedBox(
                              height: rWidth(15),
                            ),
                            Text(data[index]['review'])
                          ],
                        ),
                      );
                    }),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('No Reviews were Found.'),
              ],
            ),
    ],
  );
}
