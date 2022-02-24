import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/home/cart_screen.dart';
import 'package:levelup_egoods/screens/home/category_screen.dart';
import 'package:levelup_egoods/screens/home/home_screen.dart';
import 'package:levelup_egoods/screens/home/profile_screen.dart';
import 'package:levelup_egoods/screens/not_logged_screen.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  final PageController pageController = PageController(initialPage: 0);
  BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  final List<Widget> screenList = <Widget>[
    HomeScreen(),
    CategoryScreen(),
    Consumer<Auth>(builder: (context, auth, child) {
      print('is Authenticated = ${auth.isAuthenticated}');
      if (auth.isAuthenticated) {
        return Container(
          child: CartScreen(),
        );
      } else {
        return NotLoggedScreen();
      }
    }),
    Consumer<Auth>(builder: (context, auth, child) {
      print('is Authenticated = ${auth.isAuthenticated}');
      if (auth.isAuthenticated) {
        return ProfileScreen();
      } else {
        return NotLoggedScreen();
      }
    }),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: widget.pageController,
          children: screenList,
          onPageChanged: (value) {
            _selectedIndex = value;
            setState(() {});
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (int index) {
            widget.pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(AntIcons.homeOutlined), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(AntIcons.appstoreOutlined), label: "Categories"),
            BottomNavigationBarItem(
                icon: Icon(AntIcons.shoppingCartOutlined), label: "Cart"),
            BottomNavigationBarItem(
                icon: Icon(AntIcons.userOutlined), label: "Categories"),
          ],
        ),
      ),
    );
  }
}
