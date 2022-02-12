import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:levelup_egoods/screens/login_screen.dart';
import 'package:levelup_egoods/widgets/buttons.dart';

class NotLoggedScreen extends StatelessWidget {
  const NotLoggedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
