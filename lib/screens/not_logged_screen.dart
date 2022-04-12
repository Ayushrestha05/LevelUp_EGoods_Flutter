import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:levelup_egoods/screens/login_screen.dart';
import 'package:levelup_egoods/utilities/models/theme.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/buttons.dart';
import 'package:provider/provider.dart';

class NotLoggedScreen extends StatelessWidget {
  const NotLoggedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          StatefulBuilder(
            builder: (context, innerSetState) {
              final theme = Provider.of<AppTheme>(context);
              return Container(
                  margin: EdgeInsets.only(right: rWidth(10)),
                  child: ChoiceChip(
                    label: Icon(Icons.dark_mode_outlined,
                        color:
                            Theme.of(context).scaffoldBackgroundColor.value ==
                                    4281348144
                                ? Colors.white
                                : Colors.black),
                    selected: Theme.of(context).scaffoldBackgroundColor.value ==
                            4281348144
                        ? true
                        : false,
                    onSelected: (value) {
                      innerSetState(() =>
                          Theme.of(context).scaffoldBackgroundColor.value ==
                                  4281348144
                              ? theme.setSelectedTheme('light')
                              : theme.setSelectedTheme('dark'));
                    },
                  ));
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg_images/login2.svg',
              height: 150,
              width: 150,
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Hold Up!',
              style: TextStyle(fontFamily: 'Gotham', fontSize: 30),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50),
              child: const Text(
                'Sign up or Login to access your Personal Cart and have your personal profile.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Gotham', fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: DefaultButton("Login", () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              }),
            )
          ],
        ),
      ),
    );
  }
}
