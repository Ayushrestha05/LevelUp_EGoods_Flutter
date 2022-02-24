import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text(auth.cartItems.toString()),
        ),
      ),
    );
  }
}
