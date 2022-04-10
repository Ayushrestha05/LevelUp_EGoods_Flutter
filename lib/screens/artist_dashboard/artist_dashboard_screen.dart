import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../utilities/size_config.dart';

class ArtistDashboardScreen extends StatelessWidget {
  const ArtistDashboardScreen({Key? key}) : super(key: key);
  static const TextStyle cardStyle = TextStyle(fontFamily: 'Archivo-Regular');

  @override
  Widget build(BuildContext context) {
    final authUser = Provider.of<Auth>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: rWidth(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: rWidth(20),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        margin: EdgeInsets.only(
                            bottom: rWidth(12), top: rWidth(12)),
                        height: 100,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: FadeInImage.assetNetwork(
                            placeholder:
                                'assets/images/placeholder/Portrait_Placeholder.png',
                            image: authUser.profileImage),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          authUser.userName ?? 'User Name',
                          style: const TextStyle(
                              fontSize: 20, fontFamily: 'Archivo'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: rWidth(20),
                ),
                FutureBuilder(
                    future: getTopSellingItem(authUser),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return const Text('No Connection');

                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());

                        case ConnectionState.done:
                          var decode = jsonDecode(snapshot.data ?? '');
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 15),
                                child: Text(
                                  'Top Selling Item Currently',
                                  style: TextStyle(
                                      fontFamily: 'Kamerik-Bold',
                                      fontSize: rWidth(15)),
                                ),
                              ),
                              SizedBox(
                                width: rWidth(10),
                              ),
                              Card(
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(rWidth(5)),
                                      child: CachedNetworkImage(
                                        imageUrl: decode['item_image'],
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) {
                                          if (error != null) {}
                                          return const Icon(Icons.error);
                                        },
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: rWidth(170),
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.contain,
                                                  image: imageProvider)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: rWidth(5),
                                    ),
                                    Text(
                                      'Size : ${decode['option']}',
                                      style: cardStyle,
                                    ),
                                    SizedBox(
                                      height: rWidth(5),
                                    ),
                                    Text(
                                      'Total Quantity Sold : ${decode['total_quantity']}',
                                      style: cardStyle,
                                    ),
                                    SizedBox(
                                      height: rWidth(5),
                                    ),
                                    Text(
                                      'Total Earned : ${decode['total_price']}',
                                      style: cardStyle,
                                    ),
                                    SizedBox(
                                      height: rWidth(5),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        default:
                          return Text('Error');
                      }
                    }),
                SizedBox(
                  height: rWidth(20),
                ),
                FutureBuilder(
                    future: getTotalGeneratedIncome(authUser),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return const Text('No Connection');

                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());

                        case ConnectionState.done:
                          var decode = jsonDecode(snapshot.data ?? '');
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 15),
                                child: Text(
                                  'Dashboard',
                                  style: TextStyle(
                                      fontFamily: 'Kamerik-Bold',
                                      fontSize: rWidth(15)),
                                ),
                              ),
                              SizedBox(
                                width: rWidth(10),
                              ),
                              Card(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: rWidth(20),
                                      vertical: rWidth(20)),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Income\nGenerated',
                                            style: cardStyle,
                                          ),
                                        ),
                                        VerticalDivider(
                                          width: rWidth(10),
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: rWidth(10),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'NPR\n${decode['total_generated_income']}',
                                            style: TextStyle(
                                                fontFamily: 'Archivo'),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        default:
                          return Text('Error');
                      }
                    }),
                FutureBuilder(
                    future: getTotalSoldItems(authUser),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return const Text('No Connection');

                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());

                        case ConnectionState.done:
                          var decode = jsonDecode(snapshot.data ?? '');
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Card(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: rWidth(20),
                                      vertical: rWidth(20)),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Total\nSold Items',
                                            style: cardStyle,
                                          ),
                                        ),
                                        VerticalDivider(
                                          width: rWidth(10),
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: rWidth(10),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'QTY\n${decode['total_sold_items']}',
                                            style: TextStyle(
                                                fontFamily: 'Archivo'),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        default:
                          return Text('Error');
                      }
                    }),
                SizedBox(
                  height: rWidth(20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String>? getTopSellingItem(authUser) async {
    final response = await http.get(Uri.parse('$apiUrl/get-top-selling-item'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authUser.userToken}'
        });
    return response.body;
  }

  Future<String>? getTotalGeneratedIncome(authUser) async {
    final response = await http
        .get(Uri.parse('$apiUrl/get-total-generated-income'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authUser.userToken}'
    });
    return response.body;
  }

  Future<String>? getTotalSoldItems(authUser) async {
    final response = await http.get(Uri.parse('$apiUrl/get-total-sold-items'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authUser.userToken}'
        });
    return response.body;
  }
}
