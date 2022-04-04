import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/item_review/user_reviews_screen.dart';
import 'package:levelup_egoods/screens/order/order_screen.dart';
import 'package:levelup_egoods/screens/policies/policies_screen.dart';
import 'package:levelup_egoods/screens/report_screen.dart';
import 'package:levelup_egoods/screens/rewards/reward_items_screen.dart';
import 'package:levelup_egoods/screens/wishlist/wishlist_provider.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/models/theme.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/utilities/user_handler.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authUser = Provider.of<Auth>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: rWidth(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Theme.of(context).secondaryHeaderColor,
                    margin:
                        EdgeInsets.only(bottom: rWidth(20), top: rWidth(10)),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: rWidth(20), vertical: rWidth(20)),
                      child: Column(
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            margin: EdgeInsets.only(
                                bottom: rWidth(12), top: rWidth(12)),
                            height: 100,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: FadeInImage.assetNetwork(
                                placeholder:
                                    'assets/images/placeholder/Portrait_Placeholder.png',
                                image:
                                    "https://c.tenor.com/33OG_SodkeIAAAAd/cat-nodding.gif"),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              authUser.userName ?? 'User Name',
                              style: const TextStyle(
                                  fontSize: 20, fontFamily: 'Archivo'),
                            ),
                          ),
                          Container(
                            child: Text(
                              authUser.userEmail ?? 'User Email',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Archivo-Regular',
                                  fontWeight: FontWeight.w100),
                            ),
                          ),
                          SizedBox(
                            height: rWidth(10),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: rWidth(10), vertical: rWidth(10)),
                            decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
                                borderRadius: BorderRadius.circular(rWidth(5))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'REWARD POINTS',
                                  style: TextStyle(fontFamily: 'Archivo'),
                                ),
                                Text(
                                  authUser.userPoint.toString(),
                                  style: TextStyle(
                                      fontFamily: 'Archivo',
                                      fontSize: rWidth(30)),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        RewardItemScreen()));
                                          },
                                          child: Text('Rewards')),
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  tilePadding: EdgeInsets.symmetric(
                                      horizontal: rWidth(7)),
                                  title: const Text(
                                    'Details',
                                    style: TextStyle(fontFamily: 'Archivo'),
                                  ),
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: rWidth(5),
                                          right: rWidth(5),
                                          bottom: rWidth(10)),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    EdgeInsets.all(rWidth(5)),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(Icons.star),
                                              ),
                                              SizedBox(
                                                width: rWidth(15),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'You earn 10\% of Reward Points from Total Amount when you place an Order.',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Archivo-Regular'),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: rWidth(15),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    EdgeInsets.all(rWidth(5)),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child:
                                                    Icon(Icons.card_giftcard),
                                              ),
                                              SizedBox(
                                                width: rWidth(15),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'Use your points to redeem various items and products.',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Archivo-Regular'),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: rWidth(10), bottom: rWidth(10)),
                    child: Text(
                      'CONTENT',
                      style: TextStyle(
                          fontFamily: 'Archivo', letterSpacing: rWidth(1)),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.only(bottom: rWidth(10)),
                    color: Theme.of(context).secondaryHeaderColor,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            AntIcons.heartOutlined,
                          ),
                          title: const Text(
                            'Wishlist',
                            style: TextStyle(fontFamily: 'Archivo'),
                          ),
                          trailing:
                              const Icon(Icons.keyboard_arrow_right_sharp),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const WishlistProvider()));
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            AntIcons.shoppingOutlined,
                          ),
                          title: Text(
                            'Orders',
                            style: TextStyle(fontFamily: 'Archivo'),
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right_sharp),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const OrderListScreen()));
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            AntIcons.messageOutlined,
                          ),
                          title: Text(
                            'Reviews',
                            style: TextStyle(fontFamily: 'Archivo'),
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right_sharp),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const UserReviewsScreen()));
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: rWidth(10), bottom: rWidth(10)),
                    child: Text(
                      'PREFERENCES',
                      style: TextStyle(
                          fontFamily: 'Archivo', letterSpacing: rWidth(1)),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.only(bottom: rWidth(10)),
                    color: Theme.of(context).secondaryHeaderColor,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            AntIcons.warningOutlined,
                          ),
                          title: Text(
                            'Report',
                            style: TextStyle(fontFamily: 'Archivo'),
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right_sharp),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ReportScreen()));
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.dark_mode_outlined,
                          ),
                          title: Text(
                            'Dark Mode',
                            style: TextStyle(fontFamily: 'Archivo'),
                          ),
                          trailing: ThemeSwitch(),
                        ),
                        ListTile(
                          leading: Icon(
                            AntIcons.infoCircleOutlined,
                          ),
                          title: Text(
                            'Policies',
                            style: TextStyle(fontFamily: 'Archivo'),
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right_sharp),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => PoliciesScreen()));
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.logout,
                          ),
                          title: Text(
                            'Logout',
                            style: TextStyle(fontFamily: 'Archivo'),
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right_sharp),
                          onTap: () async {
                            await Provider.of<Auth>(context, listen: false)
                                .logout();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: rWidth(10),
                  )
                ],
              ),
            ),
          ),
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
              //color: const Color(0xFFC4C4C4),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                buttonIcon,
                color: Colors.black,
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

class ThemeSwitch extends StatefulWidget {
  const ThemeSwitch({Key? key}) : super(key: key);

  @override
  _ThemeSwitchState createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  bool _isSwitched = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTheme();
  }

  void getTheme() async {
    if (await UserHandler().getThemeData() == 'dark') {
      _isSwitched = true;
    } else {
      _isSwitched = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppTheme>(context);
    return Switch(
        value: _isSwitched,
        onChanged: (value) {
          print(Theme.of(context).scaffoldBackgroundColor.value);
          setState(() {
            _isSwitched = value;
            if (!_isSwitched) {
              theme.setSelectedTheme('light');
            } else {
              theme.setSelectedTheme('dark');
            }
          });
        });
  }
}
