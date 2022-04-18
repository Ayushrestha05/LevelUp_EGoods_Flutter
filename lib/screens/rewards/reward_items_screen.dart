import 'dart:convert';

import 'package:alert/alert.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/rewards/reward_history_screen.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:levelup_egoods/widgets/buttons.dart';
import 'package:levelup_egoods/widgets/connection-issues.dart';
import 'package:provider/provider.dart';

class RewardItemScreen extends StatelessWidget {
  const RewardItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: rWidth(20), bottom: rWidth(20)),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: rWidth(15), vertical: rWidth(10)),
                    child: Text(
                      'Reward Items',
                      style: TextStyle(
                          fontFamily: 'Kamerik-Bold', fontSize: rWidth(30)),
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => RewardHistoryScreen()));
                    },
                    icon: Icon(Icons.history)),
                SizedBox(
                  width: rWidth(10),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                  future: getRewardItems(),
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
                                    horizontal: rWidth(10)),
                                child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 0.6,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 1,
                                      crossAxisSpacing: 5,
                                    ),
                                    itemCount: decode.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.all(rWidth(5)),
                                                  child: CachedNetworkImage(
                                                    httpHeaders: const {
                                                      'Connection':
                                                          'Keep-Alive',
                                                      'Keep-Alive':
                                                          'timeout=10,max=1000'
                                                    },
                                                    imageUrl: decode[index]
                                                        ['item_image'],
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      child: const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) {
                                                      if (error != null) {
                                                        print(error);
                                                      }
                                                      return const Icon(
                                                          Icons.error);
                                                    },
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      height: 170,
                                                      //width: 200,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  imageProvider)),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: rWidth(5),
                                                      right: rWidth(5),
                                                      bottom: rWidth(3)),
                                                  child: Text(
                                                    decode[index]['item_name'],
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontFamily: 'Outfit',
                                                        fontSize: rWidth(14),
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: rWidth(3),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: rWidth(5)),
                                                  child: Text(
                                                    decode[index]
                                                            ['reward_points']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Archivo-Regular'),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: rWidth(3),
                                                ),
                                                decode[index]['stock'] == 0
                                                    ? Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    rWidth(5)),
                                                        child: Text(
                                                          'Out of Stock',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Archivo-Regular'),
                                                        ),
                                                      )
                                                    : Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    rWidth(5)),
                                                        child: Text(
                                                          'Stock Left : ${decode[index]['stock'].toString()}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Archivo-Regular'),
                                                        ),
                                                      ),
                                                SizedBox(
                                                  height: rWidth(3),
                                                ),
                                                decode[index]['stock'] == 0
                                                    ? Container()
                                                    : Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: DefaultButton(
                                                            'Redeem', () {
                                                          redeemItem(
                                                              context: context,
                                                              reward_id: decode[
                                                                          index]
                                                                      ['id']
                                                                  .toString());
                                                        }))
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              )
                            : buildNoDataError(
                                text: 'No Reward Items were Found.');

                      default:
                        return buildDefaultError();
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<String>? getRewardItems() async {
    var response = await http.get(Uri.parse('$apiUrl/reward-items'), headers: {
      'Accept': 'application/json',
    });
    return response.body;
  }

  void redeemItem(
      {required BuildContext context, required String reward_id}) async {
    final auth = Provider.of<Auth>(context, listen: false);
    var response = await http.post(Uri.parse('$apiUrl/redeem-item'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${auth.userToken}'
    }, body: {
      'reward_id': reward_id
    });
    var decode = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Alert(message: decode['message']).show();
      auth.getUserPoints();
      Navigator.pop(context);
    } else {
      Alert(message: decode['message']).show();
    }
  }
}
