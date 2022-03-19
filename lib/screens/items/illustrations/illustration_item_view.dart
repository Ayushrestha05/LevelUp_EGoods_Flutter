import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/models/illustration.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/bottomNavigationItemBar.dart';
import 'package:provider/provider.dart';

class IllustrationView extends StatelessWidget {
  final String imageURL;
  final String heroTag;
  const IllustrationView(
      {Key? key, required this.imageURL, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final illustration = Provider.of<Illustration>(context);
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: buildBottomNavigationBarItem(
        illustration.getSelectedPrice(),
        () {
          auth.addToCart(context, illustration.id, illustration.option);
        },
      ),
      body: Container(
        padding:
            EdgeInsets.symmetric(horizontal: rWidth(10), vertical: rWidth(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: heroTag,
              child: CachedNetworkImage(
                imageUrl: imageURL,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) {
                  if (error != null) {}
                  return const Icon(Icons.error);
                },
                imageBuilder: (context, imageProvider) => Container(
                  height: rWidth(170),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.contain, image: imageProvider)),
                ),
              ),
            ),
            SizedBox(
              height: rWidth(20),
            ),
            Text(
              'Sizes Available',
              style: TextStyle(fontSize: rWidth(10), fontFamily: 'Outfit'),
            ),
            SizedBox(
              height: rWidth(5),
            ),
            Container(
              height: rWidth(40),
              child: ListView.builder(
                  itemCount: illustration.illustration_prices.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (builder, index) {
                    return Container(
                      margin: EdgeInsets.only(right: rWidth(5)),
                      child: illustration.selected ==
                              illustration.illustration_prices[index]['id']
                          ? ElevatedButton(
                              child: Text(illustration
                                  .illustration_prices[index]['size']),
                              onPressed: () {
                                illustration.setSelected(illustration
                                    .illustration_prices[index]['id']);
                              },
                            )
                          : OutlinedButton(
                              child: Text(illustration
                                  .illustration_prices[index]['size']),
                              onPressed: () {
                                illustration.setSelected(illustration
                                    .illustration_prices[index]['id']);
                              },
                            ),
                    );
                  }),
            ),
            SizedBox(
              height: rWidth(20),
            ),
            Text(
              illustration.name,
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: rWidth(20),
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: rWidth(20),
            ),
            Text(
              illustration.description,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontFamily: 'Archivo-Regular',
                  color: const Color(0xFF686868),
                  fontSize: rWidth(12)),
            ),
          ],
        ),
      ),
    ));
  }
}
