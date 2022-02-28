import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/titleContainer.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    print(auth.cartItems);
    return SafeArea(
      child: Scaffold(
        body: auth.cartItems.length > 0
            ? ListView.builder(
                itemCount: auth.cartItems.length + 1,
                itemBuilder: (context, index) {
                  --index;
                  if (index == -1) {
                    return buildTitle(context, 'My Cart');
                  } else {
                    return Container(
                      margin: EdgeInsets.only(bottom: rWidth(20)),
                      child: Dismissible(
                        key: UniqueKey(),
                        background: onDismissContainer(MainAxisAlignment.start),
                        secondaryBackground:
                            onDismissContainer(MainAxisAlignment.end),
                        onDismissed: (direction) {
                          print('dismissed');
                          auth.removeItemFromCart(
                              context, auth.cartItems[index]['cart_item_id']);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: rWidth(18)),
                          padding: EdgeInsets.symmetric(
                              horizontal: rWidth(8), vertical: rWidth(14)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(rWidth(5)),
                            color: Color(0xFFFAFAFA),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                  httpHeaders: const {
                                    'Connection': 'Keep-Alive',
                                    'Keep-Alive': 'timeout=10,max=1000'
                                  },
                                  imageUrl: auth.cartItems[index]['item_image'],
                                  placeholder: (context, url) => Container(
                                      width: rWidth(84),
                                      height: rWidth(110),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(rWidth(5)),
                                        color: Colors.grey,
                                      ),
                                      child: const Expanded(
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()))),
                                  errorWidget: (context, url, error) {
                                    if (error != null) {
                                      print(error);
                                    }
                                    return Container(
                                        width: rWidth(84),
                                        height: rWidth(110),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(rWidth(10)),
                                          color: Colors.grey,
                                        ),
                                        child: const Expanded(
                                            child: Center(
                                                child: Icon(Icons.error))));
                                  },
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        width: rWidth(84),
                                        height: rWidth(110),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(rWidth(10)),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: imageProvider,
                                          ),
                                        ),
                                      )),
                              SizedBox(
                                width: rWidth(10),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        auth.cartItems[index]['item_name'],
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontFamily: 'Outfit',
                                            fontSize: rWidth(16)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      'NPR',
                                      style: TextStyle(
                                          fontFamily: 'Righteous',
                                          fontSize: rWidth(12),
                                          fontWeight: FontWeight.w100),
                                    ),
                                    Text(
                                      auth.cartItems[index]['current_price']
                                          .toString(),
                                      style: TextStyle(
                                          fontFamily: 'Righteous',
                                          fontSize: rWidth(18)),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              auth.decreaseItemQuantity(
                                                  context,
                                                  auth.cartItems[index]
                                                      ['cart_item_id']);
                                            },
                                            icon: Icon(Icons
                                                .indeterminate_check_box_outlined)),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            auth.cartItems[index]['quantity']
                                                .toString(),
                                            style: TextStyle(
                                                fontFamily: 'Archivo'),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              auth.increaseItemQuantity(
                                                  context,
                                                  auth.cartItems[index]
                                                      ['cart_item_id']);
                                            },
                                            icon: Icon(Icons.add_box_outlined)),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                })
            : buildEmptyCart(),
      ),
    );
  }

  Widget onDismissContainer(MainAxisAlignment alignment) {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: alignment,
          children: const <Widget>[
            Icon(Icons.delete, color: Colors.white),
            Text('Remove Item', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg_images/emptyCart.svg',
            height: rWidth(200),
            width: rWidth(200),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 50),
            child: const Text(
              'No Items Found in your cart. Add Items to view your cart.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Gotham', fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
