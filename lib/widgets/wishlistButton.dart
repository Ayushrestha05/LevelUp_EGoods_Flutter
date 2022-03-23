import 'dart:convert';

import 'package:alert/alert.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class WishlistButton extends StatefulWidget {
  final int itemID;
  final BuildContext ctx;
  const WishlistButton({Key? key, required this.itemID, required this.ctx})
      : super(key: key);

  @override
  State<WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<WishlistButton> {
  bool isWishlisted = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isInWishlist();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return IconButton(
      icon: isWishlisted
          ? const Icon(
              AntIcons.heartFilled,
              color: Colors.indigo,
            )
          : const Icon(AntIcons.heartOutlined),
      onPressed: () {
        if (auth.isAuthenticated) {
          isWishlisted ? removeFromWishlist() : addToWishlist();
        } else {
          Alert(message: 'You have not logged in.').show();
        }
      },
    );
  }

  void isInWishlist() async {
    final auth = Provider.of<Auth>(widget.ctx, listen: false);
    if (auth.isAuthenticated == true) {
      var response = await http.get(
        Uri.parse('$apiUrl/in-wishlist/${widget.itemID}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${auth.userToken}',
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        isWishlisted = true;
      } else {
        isWishlisted = false;
      }
      setState(() {});
    }
  }

  void addToWishlist() async {
    final auth = Provider.of<Auth>(widget.ctx, listen: false);
    var response = await http.post(Uri.parse('$apiUrl/add-wishlist'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${auth.userToken}',
    }, body: {
      'item_id': widget.itemID.toString()
    });

    var decode = jsonDecode(response.body);
    if (response.statusCode == 200) {
      isWishlisted = true;
      Alert(message: decode['message']).show();
      setState(() {});
    } else {
      Alert(message: decode['message']).show();
    }
  }

  void removeFromWishlist() async {
    final auth = Provider.of<Auth>(widget.ctx, listen: false);
    var response =
        await http.post(Uri.parse('$apiUrl/remove-wishlist'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${auth.userToken}',
    }, body: {
      'item_id': widget.itemID.toString()
    });

    var decode = jsonDecode(response.body);
    if (response.statusCode == 200) {
      isWishlisted = false;
      Alert(message: decode['message']).show();
      setState(() {});
    } else {
      Alert(message: decode['message']).show();
    }
  }
}
