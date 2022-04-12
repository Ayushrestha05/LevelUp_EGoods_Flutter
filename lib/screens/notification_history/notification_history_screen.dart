import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:http/http.dart' as http;

class NotificationHistoryScreen extends StatelessWidget {
  const NotificationHistoryScreen({Key? key}) : super(key: key);

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
            child: Text(
              'Notifications',
              style:
                  TextStyle(fontFamily: 'Kamerik-Bold', fontSize: rWidth(30)),
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: rWidth(15)),
              child: FutureBuilder(
                future: getNotificationHistory(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Text('No Connection');

                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());

                    case ConnectionState.done:
                      var decode = jsonDecode(snapshot.data ?? '');

                      return decode.length == 0
                          ? Text('No Data Sir')
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: decode.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: rWidth(20),
                                        vertical: rWidth(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          decode['notifications'][index]
                                              ['title'],
                                          style:
                                              TextStyle(fontFamily: 'Archivo'),
                                        ),
                                        SizedBox(
                                          height: rWidth(5),
                                        ),
                                        Text(
                                          decode['notifications'][index]
                                              ['body'],
                                          style: TextStyle(
                                              fontFamily: 'Archivo-Regular'),
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'Sent at ${DateFormat('yyyy-MM-dd').format(DateTime.parse(decode['notifications'][index]['created_at']))}',
                                            style: TextStyle(
                                                fontFamily: 'Archivo-Regular',
                                                color: Colors.grey.shade500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });

                    default:
                      return Text('Error');
                  }
                },
              )),
        ],
      ),
    ));
  }

  Future<String>? getNotificationHistory() async {
    var response =
        await http.get(Uri.parse('$apiUrl/get-notifications'), headers: {
      'Accept': 'application/json',
    });
    return response.body;
  }
}
