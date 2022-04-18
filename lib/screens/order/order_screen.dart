import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:levelup_egoods/screens/order/order_summary_screen.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:levelup_egoods/widgets/connection-issues.dart';
import 'package:provider/provider.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  static const _textStyle =
      TextStyle(fontFamily: 'Archivo', color: Colors.black);
  static const _unselectedTextStyle = TextStyle(fontFamily: 'Archivo');
  bool allOption = true, pendingOption = false, completedOption = false;

  get selectedIndex => null;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: rWidth(15),
                  right: rWidth(15),
                  top: rWidth(30),
                  bottom: rWidth(20)),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: rWidth(20), vertical: rWidth(10)),
                child: Text(
                  'Orders',
                  style: TextStyle(
                      fontFamily: 'Kamerik-Bold', fontSize: rWidth(30)),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: rWidth(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  allOption
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: rWidth(20), vertical: rWidth(10)),
                          decoration: BoxDecoration(
                              color: const Color(0xFF6FFFE9),
                              borderRadius: BorderRadius.circular(rWidth(15))),
                          child: const Text(
                            'All',
                            style: _textStyle,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            allOption = true;
                            pendingOption = false;
                            completedOption = false;
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: rWidth(20), vertical: rWidth(10)),
                            child: Text(
                              'All',
                              style: _unselectedTextStyle,
                            ),
                          ),
                        ),
                  pendingOption
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: rWidth(20), vertical: rWidth(10)),
                          decoration: BoxDecoration(
                              color: const Color(0xFF6FFFE9),
                              borderRadius: BorderRadius.circular(rWidth(15))),
                          child: const Text(
                            'Pending',
                            style: _textStyle,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            allOption = false;
                            pendingOption = true;
                            completedOption = false;
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: rWidth(20), vertical: rWidth(10)),
                            child: Text(
                              'Pending',
                              style: _unselectedTextStyle,
                            ),
                          ),
                        ),
                  completedOption
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: rWidth(20), vertical: rWidth(10)),
                          decoration: BoxDecoration(
                              color: const Color(0xFF6FFFE9),
                              borderRadius: BorderRadius.circular(rWidth(15))),
                          child: const Text(
                            'Completed',
                            style: _textStyle,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            allOption = false;
                            pendingOption = false;
                            completedOption = true;
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: rWidth(20), vertical: rWidth(10)),
                            child: Text(
                              'Completed',
                              style: _unselectedTextStyle,
                            ),
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(
              height: rWidth(20),
            ),
            Expanded(
              child: FutureBuilder(
                  future: getUserOrders(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return buildNoConnectionError();

                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());

                      case ConnectionState.done:
                        var decode = jsonDecode(snapshot.data ?? '');

                        return decode.length > 0
                            ? Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: rWidth(20)),
                                child: ListView.builder(
                                    itemCount: decode.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: ListTile(
                                          leading: decode[index]['status'] ==
                                                  'pending'
                                              ? Icon(Icons.hourglass_empty)
                                              : Icon(Icons.check),
                                          trailing: Icon(Icons.chevron_right),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        OrderSummaryScreen(
                                                          orderID: decode[index]
                                                              ['id'],
                                                        )));
                                          },
                                          title: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    decode[index]['txn_id'],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors
                                                            .grey.shade400,
                                                        fontFamily:
                                                            'Archivo-Regular',
                                                        fontSize: rWidth(12)),
                                                  ),
                                                  Text(
                                                      decode[index]
                                                          ['created_at'],
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Archivo-Regular'))
                                                ],
                                              ),
                                              Spacer(),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'NPR',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .grey.shade400,
                                                        fontFamily:
                                                            'Archivo-Regular',
                                                        fontSize: rWidth(12)),
                                                  ),
                                                  Text(
                                                    decode[index]['total']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'Archivo'),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            : buildNoDataError(text: 'No Orders were Found.');
                      default:
                        return buildDefaultError();
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  Future<String>? getUserOrders() async {
    final auth = Provider.of<Auth>(context, listen: false);
    String filterString;
    if (completedOption) {
      filterString = "completed";
    } else if (pendingOption) {
      filterString = "pending";
    } else {
      filterString = "all";
    }
    var response = await http.post(Uri.parse('$apiUrl/get-orders'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${auth.userToken}'
    }, body: {
      'filter': filterString,
    });
    return response.body;
  }
}
