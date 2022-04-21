import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PoliciesScreen extends StatelessWidget {
  const PoliciesScreen({Key? key}) : super(key: key);
  static const TextStyle _textStyle = TextStyle(fontFamily: 'Archivo');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Policies',
              style: _textStyle,
            ),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Privacy Policy',
                ),
                Tab(text: 'Terms and Conditions')
              ],
            ),
          ),
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: '$webUrl/privacy-policy',
              ),
              WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl:
                    'https://www.termsfeed.com/blog/sample-terms-and-conditions-template/',
              )
            ],
          ),
        ),
      ),
    );
  }
}
