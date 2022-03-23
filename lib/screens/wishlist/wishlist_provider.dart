import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/wishlist/wishlist_screen.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/models/wishlist.dart';
import 'package:provider/provider.dart';

class WishlistProvider extends StatelessWidget {
  const WishlistProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return ChangeNotifierProvider(
      create: (context) => Wishlist(auth),
      child: WishlistScreen(),
    );
  }
}
