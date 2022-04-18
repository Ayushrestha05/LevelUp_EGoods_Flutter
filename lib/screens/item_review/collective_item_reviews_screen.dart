import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/connection-issues.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CollectiveItemReviewsScreen extends StatefulWidget {
  final int item_id;
  const CollectiveItemReviewsScreen({Key? key, required this.item_id})
      : super(key: key);

  @override
  State<CollectiveItemReviewsScreen> createState() =>
      _CollectiveItemReviewsScreenState();
}

class _CollectiveItemReviewsScreenState
    extends State<CollectiveItemReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: rWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  right: rWidth(15), top: rWidth(30), bottom: rWidth(10)),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: rWidth(10)),
                child: Text(
                  'Reviews',
                  style: TextStyle(
                      fontFamily: 'Kamerik-Bold', fontSize: rWidth(30)),
                ),
              ),
            ),
            FutureBuilder(
                future: getUserReviews(),
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
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: decode.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: rWidth(10),
                                      vertical: rWidth(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Purchased By ${decode[index]['user']}',
                                        style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontFamily: 'Archivo-Regular'),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Purchased On ${decode[index]['created_at']}',
                                            style: TextStyle(
                                                color: Colors.grey.shade400,
                                                fontFamily: 'Archivo-Regular'),
                                          ),
                                        ],
                                      ),
                                      Text(decode[index]['review']),
                                      SizedBox(
                                        height: rWidth(5),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: RatingBarIndicator(
                                          rating: decode[index]['rating']
                                              .toDouble(),
                                          itemBuilder: (context, index) =>
                                              const Icon(Icons.star,
                                                  color: Colors.amber),
                                          itemCount: 5,
                                          itemSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        height: rWidth(10),
                                      ),
                                    ],
                                  ),
                                );
                              })
                          : buildNoDataError(text: 'No Reviews Found.');

                    default:
                      return buildDefaultError();
                  }
                })
          ],
        ),
      ),
    )));
  }

  Future<String>? getUserReviews() async {
    final auth = Provider.of<Auth>(context, listen: false);
    print('$apiUrl/get-user-reviews/${widget.item_id}');
    var response = await http
        .get(Uri.parse('$apiUrl/get-all-reviews/${widget.item_id}'), headers: {
      'Accept': 'application/json',
    });
    return response.body;
  }
}
