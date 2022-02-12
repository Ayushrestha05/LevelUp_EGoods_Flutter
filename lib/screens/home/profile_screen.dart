import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/report_screen.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authUser = Provider.of<Auth>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 90,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 100,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://c.tenor.com/33OG_SodkeIAAAAd/cat-nodding.gif")),
                  shape: BoxShape.circle,
                  color: Colors.red),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Text(
                authUser.userName ?? 'User Name',
                style: const TextStyle(fontSize: 20, fontFamily: 'Archivo'),
              ),
            ),
            Container(
              child: Text(
                authUser.userEmail ?? 'User Email',
                style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Archivo-Italic',
                    fontWeight: FontWeight.w100),
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildProfileButton(
                        buttonName: "My Wishlist",
                        buttonIcon: AntIcons.heartOutlined,
                        onTap: () {},
                      ),
                      buildProfileButton(
                        buttonName: "Settings",
                        buttonIcon: AntIcons.settingOutlined,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildProfileButton(
                        buttonName: "Report",
                        buttonIcon: AntIcons.warningOutlined,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ReportScreen()));
                        },
                      ),
                      buildProfileButton(
                        buttonName: "Logout",
                        buttonIcon: Icons.logout,
                        onTap: () async {
                          await Provider.of<Auth>(context, listen: false)
                              .logout();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Privacy Policy",
                    style: TextStyle(
                        fontFamily: 'Archivo-Italic',
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: rWidth(5)),
                      child: const Text("--")),
                  const Text(
                    "Terms and Conditions",
                    style: TextStyle(
                        fontFamily: 'Archivo-Italic',
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class buildProfileButton extends StatelessWidget {
  final String buttonName;
  final IconData buttonIcon;
  final Function() onTap;
  const buildProfileButton({
    Key? key,
    required this.buttonName,
    required this.buttonIcon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFC4C4C4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                buttonIcon,
                size: 32,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            buttonName,
            style: const TextStyle(
                fontFamily: 'Archivo-Italic', fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
