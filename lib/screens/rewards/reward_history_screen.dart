import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class RewardHistoryScreen extends StatelessWidget {
  const RewardHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: rWidth(20), bottom: rWidth(20)),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: rWidth(15), vertical: rWidth(10)),
              child: Text(
                'Redeemed Rewards History',
                style:
                    TextStyle(fontFamily: 'Kamerik-Bold', fontSize: rWidth(30)),
              ),
            ),
          ),
          FutureBuilder(
              future: getRewardItems(context: context),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Expanded(
                        child: Center(child: Text('No Connection')));

                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());

                  case ConnectionState.done:
                    var decode = jsonDecode(snapshot.data ?? '');
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: decode.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(top: rWidth(10)),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: rWidth(10)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CachedNetworkImage(
                                        httpHeaders: const {
                                          'Connection': 'Keep-Alive',
                                          'Keep-Alive': 'timeout=10,max=1000'
                                        },
                                        imageUrl: decode[index]['reward_image'],
                                        placeholder: (context, url) =>
                                            Container(
                                                width: rWidth(84),
                                                height: rWidth(120),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          rWidth(5)),
                                                  color: Colors.grey,
                                                ),
                                                child: const Expanded(
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator()))),
                                        errorWidget: (context, url, error) {
                                          if (error != null) {
                                            print(error);
                                          }
                                          return Container(
                                              width: rWidth(110),
                                              height: rWidth(120),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        rWidth(10)),
                                                color: Colors.grey,
                                              ),
                                              child: const Expanded(
                                                  child: Center(
                                                      child:
                                                          Icon(Icons.error))));
                                        },
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: rWidth(110),
                                          height: rWidth(120),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                rWidth(10)),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: imageProvider,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: rWidth(10),
                                              right: rWidth(10)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                child: Text(
                                                  decode[index]['reward_item'],
                                                  style: TextStyle(
                                                      fontFamily: 'Outfit',
                                                      fontSize: rWidth(15)),
                                                ),
                                              ),
                                              SizedBox(
                                                height: rWidth(5),
                                              ),
                                              Text(
                                                'Redeemed on ${decode[index]['created_at']}',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Archivo-Regular'),
                                              ),
                                              SizedBox(
                                                height: rWidth(5),
                                              ),
                                              Text(
                                                'Status : ${decode[index]['status']}',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Archivo-Regular'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: rWidth(10),
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );

                  default:
                    return Text('Error');
                }
              }),
        ],
      ),
    ));
  }

  Future<String>? getRewardItems({required BuildContext context}) async {
    final auth = Provider.of<Auth>(context, listen: false);
    var response = await http.get(Uri.parse('$apiUrl/get-redeemed-items'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${auth.userToken}'
        });
    return response.body;
  }
}
