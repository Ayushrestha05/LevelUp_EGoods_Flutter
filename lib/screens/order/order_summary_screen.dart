import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/item_review/item_review_screen.dart';
import 'package:levelup_egoods/screens/items/item_screen_switch.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class OrderSummaryScreen extends StatelessWidget {
  final int orderID;
  OrderSummaryScreen({Key? key, required this.orderID}) : super(key: key);
  static const TextStyle summaryStyle =
      TextStyle(fontFamily: 'Archivo-Regular');

  var textStyle = TextStyle(
    fontFamily: 'Archivo-Regular',
    fontSize: rWidth(14),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: rWidth(20),
                      right: rWidth(15),
                      top: rWidth(30),
                      bottom: rWidth(10)),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: rWidth(10)),
                    child: Text(
                      'Order Summary',
                      style: TextStyle(
                          fontFamily: 'Kamerik-Bold', fontSize: rWidth(30)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: rWidth(20)),
                  child: FutureBuilder(
                      future: getOrderSummary(context),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return const Text('No Connection');

                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());

                          case ConnectionState.done:
                            var decode = jsonDecode(snapshot.data ?? '');
                            var order = decode[0]['order'] ?? '';
                            var items = decode[0]['items'] ?? '';
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: rWidth(20),
                                        vertical: rWidth(20)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Order ID : ${order['id'].toString()}',
                                          style: textStyle,
                                        ),
                                        SizedBox(
                                          height: rWidth(5),
                                        ),
                                        Text(
                                          'Token ID : ${order['txn_id'].toString()}',
                                          style: textStyle,
                                        ),
                                        SizedBox(
                                          height: rWidth(5),
                                        ),
                                        Text(
                                          'Placed On : ${order['created_at']}',
                                          style: textStyle,
                                        ),
                                        SizedBox(
                                          height: rWidth(5),
                                        ),
                                        Text(
                                          'Amount Paid : ${order['total'].toString()} NPR',
                                          style: textStyle,
                                        ),
                                        SizedBox(
                                          height: rWidth(5),
                                        ),
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          child: order['status'] == 'pending'
                                              ? Icon(Icons.hourglass_empty)
                                              : Icon(Icons.check),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: rWidth(10),
                                ),
                                Text(
                                  'Reciever Details',
                                  style: TextStyle(
                                      fontFamily: 'Archivo',
                                      fontSize: rWidth(20)),
                                ),
                                SizedBox(
                                  height: rWidth(10),
                                ),
                                Card(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: rWidth(20),
                                        vertical: rWidth(20)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order['reciever_name'],
                                          style: textStyle,
                                        ),
                                        Text(
                                          order['reciever_address'],
                                          style: textStyle,
                                        ),
                                        Text(
                                          order['reciever_city'],
                                          style: textStyle,
                                        ),
                                        Text(
                                          order['reciever_phone'],
                                          style: textStyle,
                                        ),
                                        Text(
                                          order['reciever_email'],
                                          style: textStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: rWidth(10),
                                ),
                                Text(
                                  'Delivery Options',
                                  style: TextStyle(
                                      fontFamily: 'Archivo',
                                      fontSize: rWidth(20)),
                                ),
                                SizedBox(
                                  height: rWidth(10),
                                ),
                                Card(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: rWidth(20),
                                        vertical: rWidth(10)),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Non-Transparent Bag',
                                              style: textStyle,
                                            ),
                                            Checkbox(
                                                value: order['hidden'] == 1
                                                    ? true
                                                    : false,
                                                onChanged: null),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Gift Wrapped',
                                              style: textStyle,
                                            ),
                                            Checkbox(
                                                value: order['wrapped'] == 1
                                                    ? true
                                                    : false,
                                                onChanged: null),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: rWidth(10),
                                ),
                                order['sender_message'] != null
                                    ? Text(
                                        'Message Attached',
                                        style: TextStyle(
                                            fontFamily: 'Archivo',
                                            fontSize: rWidth(20)),
                                      )
                                    : Container(),
                                SizedBox(
                                  height: rWidth(10),
                                ),
                                order['sender_message'] != null ||
                                        order['sender_message'] != ''
                                    ? Text(
                                        order['sender_message'] ?? '',
                                        style: textStyle,
                                      )
                                    : Container(),
                                SizedBox(
                                  height: rWidth(10),
                                ),
                                Text(
                                  'Order Items',
                                  style: TextStyle(
                                      fontFamily: 'Archivo',
                                      fontSize: rWidth(20)),
                                ),
                                SizedBox(
                                  height: rWidth(10),
                                ),
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      return buildCartContainer(
                                          context, items, index);
                                    }),
                                SizedBox(
                                  height: rWidth(10),
                                ),
                                Text(
                                  'Payment Summary',
                                  style: TextStyle(
                                      fontFamily: 'Archivo',
                                      fontSize: rWidth(20)),
                                ),
                                SizedBox(
                                  height: rWidth(10),
                                ),
                                Card(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: rWidth(15),
                                        vertical: rWidth(10)),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Text('Subtotal',
                                                style: summaryStyle),
                                            const Spacer(),
                                            Text(
                                              order['sub_total'].toString(),
                                              style: const TextStyle(
                                                  fontFamily: 'Archivo'),
                                            ),
                                            SizedBox(
                                              width: rWidth(3),
                                            ),
                                            const Text(
                                              'NPR',
                                              style: TextStyle(
                                                  fontFamily: 'Archivo'),
                                            )
                                          ],
                                        ),
                                        order['discount_percent'] != 0
                                            ? Row(
                                                children: [
                                                  Text(
                                                      'Discount (${order['discount_percentage']}%)',
                                                      style: summaryStyle),
                                                  const Spacer(),
                                                  Text(
                                                    order['discount_amount']
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontFamily: 'Archivo'),
                                                  ),
                                                  SizedBox(
                                                    width: rWidth(3),
                                                  ),
                                                  const Text(
                                                    'NPR',
                                                    style: TextStyle(
                                                        fontFamily: 'Archivo'),
                                                  )
                                                ],
                                              )
                                            : Container(),
                                        Row(
                                          children: [
                                            Text('Total', style: summaryStyle),
                                            const Spacer(),
                                            Text(
                                              order['total'].toString(),
                                              style: const TextStyle(
                                                  fontFamily: 'Archivo'),
                                            ),
                                            SizedBox(
                                              width: rWidth(3),
                                            ),
                                            const Text(
                                              'NPR',
                                              style: TextStyle(
                                                  fontFamily: 'Archivo'),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: rWidth(5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: rWidth(10),
                                ),
                              ],
                            );
                            break;

                          default:
                            return Text('Error');
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String>? getOrderSummary(BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    String filterString;
    var response = await http.get(
        Uri.parse('$apiUrl/get-order-details/${orderID.toString()}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${auth.userToken}'
        });

    return response.body;
  }

  Container buildCartContainer(BuildContext context, var items, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: rWidth(10)),
      padding:
          EdgeInsets.symmetric(horizontal: rWidth(8), vertical: rWidth(14)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(rWidth(10)),
          color: Theme.of(context).secondaryHeaderColor),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              itemScreen(
                  context: context,
                  categoryID: items[index]['category'],
                  itemID: items[index]['item_id'],
                  imageURL: items[index]['item_image'],
                  heroTag: 'orderImage${items[index]['id']}');
            },
            child: Hero(
              tag: 'orderImage${items[index]['id']}',
              child: CachedNetworkImage(
                  httpHeaders: const {
                    'Connection': 'Keep-Alive',
                    'Keep-Alive': 'timeout=10,max=1000'
                  },
                  imageUrl: items[index]['item_image'],
                  placeholder: (context, url) => Container(
                      width: rWidth(84),
                      height: rWidth(120),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(rWidth(5)),
                        color: Colors.grey,
                      ),
                      child: const Expanded(
                          child: Center(child: CircularProgressIndicator()))),
                  errorWidget: (context, url, error) {
                    if (error != null) {
                      print(error);
                    }
                    return Container(
                        width: rWidth(84),
                        height: rWidth(110),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(rWidth(10)),
                          color: Colors.grey,
                        ),
                        child: const Expanded(
                            child: Center(child: Icon(Icons.error))));
                  },
                  imageBuilder: (context, imageProvider) => Container(
                        width: rWidth(84),
                        height: rWidth(120),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(rWidth(10)),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: imageProvider,
                          ),
                        ),
                      )),
            ),
          ),
          SizedBox(
            width: rWidth(10),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    items[index]['item_name'],
                    maxLines: 2,
                    style:
                        TextStyle(fontFamily: 'Outfit', fontSize: rWidth(16)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'NPR',
                  style: TextStyle(
                      fontFamily: 'Righteous',
                      fontSize: rWidth(12),
                      fontWeight: FontWeight.w100),
                ),
                Text(
                  items[index]['unit_price'].toString(),
                  style:
                      TextStyle(fontFamily: 'Righteous', fontSize: rWidth(18)),
                ),
                SizedBox(
                  height: rWidth(5),
                ),
                items[index]['option'] != null
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: rWidth(10), vertical: rWidth(5)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              rWidth(3),
                            ),
                            border: Border.all(color: Colors.brown)),
                        child: Text(
                          items[index]['option'],
                          style: TextStyle(fontFamily: 'Archivo'),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: rWidth(5),
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          'QTY',
                          style: TextStyle(
                              fontFamily: 'Righteous', fontSize: rWidth(15)),
                        ),
                        Text(
                          '${items[index]['quantity'].toString()}',
                          style: TextStyle(
                              fontFamily: 'Righteous', fontSize: rWidth(15)),
                        )
                      ],
                    ),
                    Spacer(),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ItemReviewScreen(
                                        item_details: items[index],
                                      )));
                        },
                        child: Text('Add a Review'))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
