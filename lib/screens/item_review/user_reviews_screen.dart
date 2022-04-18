import 'dart:convert';

import 'package:alert/alert.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/connection-issues.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class UserReviewsScreen extends StatefulWidget {
  const UserReviewsScreen({Key? key}) : super(key: key);

  @override
  State<UserReviewsScreen> createState() => _UserReviewsScreenState();
}

class _UserReviewsScreenState extends State<UserReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
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
              Expanded(
                child: FutureBuilder(
                    future: getUserReviews(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return buildNoConnectionError();

                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());

                        case ConnectionState.done:
                          var decode = jsonDecode(snapshot.data ?? '');
                          return decode.length > 0
                              ? ListView.builder(
                                  itemCount: decode.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: rWidth(10),
                                          vertical: rWidth(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Purchased On ${decode[index]['created_at']}',
                                                style: TextStyle(
                                                    color: Colors.grey.shade400,
                                                    fontFamily:
                                                        'Archivo-Regular'),
                                              ),
                                              Spacer(),
                                              IconButton(
                                                  onPressed: () {
                                                    showDialog<void>(
                                                      context: context,
                                                      barrierDismissible:
                                                          false, // user must tap button!
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text('Alert'),
                                                          content: Text(
                                                              'Do you want to delete your review?'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child:
                                                                  Text('Yes'),
                                                              onPressed: () {
                                                                deleteReview(
                                                                    id: decode[
                                                                            index]
                                                                        ['id']);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text(
                                                                  'Cancel'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  icon: Icon(Icons
                                                      .delete_forever_rounded))
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
                                          Container(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: rWidth(10),
                                                vertical: rWidth(10)),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CachedNetworkImage(
                                                    httpHeaders: const {
                                                      'Connection':
                                                          'Keep-Alive',
                                                      'Keep-Alive':
                                                          'timeout=10,max=1000'
                                                    },
                                                    imageUrl: decode[index]
                                                        ['item_image'],
                                                    placeholder: (context,
                                                            url) =>
                                                        Container(
                                                            width: rWidth(84),
                                                            height: rWidth(120),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          rWidth(
                                                                              5)),
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            child: const Expanded(
                                                                child: Center(
                                                                    child:
                                                                        CircularProgressIndicator()))),
                                                    errorWidget:
                                                        (context, url, error) {
                                                      if (error != null) {
                                                        print(error);
                                                      }
                                                      return Container(
                                                          width: rWidth(50),
                                                          height: rWidth(50),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        rWidth(
                                                                            10)),
                                                            color: Colors.grey,
                                                          ),
                                                          child: const Expanded(
                                                              child: Center(
                                                                  child: Icon(Icons
                                                                      .error))));
                                                    },
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                          width: rWidth(50),
                                                          height: rWidth(50),
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  imageProvider,
                                                            ),
                                                          ),
                                                        )),
                                                SizedBox(
                                                  width: rWidth(10),
                                                ),
                                                Expanded(
                                                    child: Text(decode[index]
                                                        ['item_name'])),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  })
                              : buildNoDataError(text: 'No Reviews Found.');

                        default:
                          return buildDefaultError();
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String>? getUserReviews() async {
    final auth = Provider.of<Auth>(context, listen: false);
    var response = await http.get(Uri.parse('$apiUrl/get-user-reviews'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${auth.userToken}'
        });
    return response.body;
  }

  void deleteReview({id}) async {
    final auth = Provider.of<Auth>(context, listen: false);
    var response = await http.post(Uri.parse('$apiUrl/delete-review'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${auth.userToken}'
        },
        body: {
          'id': '$id'
        });

    var decode = jsonDecode(response.body);
    Alert(message: decode['message']).show();
    setState(() {});
  }
}
