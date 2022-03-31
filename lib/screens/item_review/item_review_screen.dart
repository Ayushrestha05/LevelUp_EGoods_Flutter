import 'dart:convert';

import 'package:alert/alert.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/buttons.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

class ItemReviewScreen extends StatefulWidget {
  final item_details;
  const ItemReviewScreen({Key? key, required this.item_details})
      : super(key: key);

  @override
  State<ItemReviewScreen> createState() => _ItemReviewScreenState();
}

class _ItemReviewScreenState extends State<ItemReviewScreen> {
  final _reviewFormKey = GlobalKey<FormState>();
  final TextEditingController _reviewText = TextEditingController();
  double _ratingStars = 1;
  double _initialRatingStars = 1;
  bool _existingReview = false;

  @override
  void initState() {
    super.initState();
    getUserReview();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          child: DefaultButton(
              _existingReview ? 'Update Review' : 'Save Review', () {
            if (_reviewFormKey.currentState!.validate()) {
              if (_existingReview) {
                updateUserReview(
                    item_id: widget.item_details['item_id'],
                    rating: _ratingStars,
                    review: _reviewText.text);
              } else {
                addReview(
                    item_id: widget.item_details['item_id'],
                    rating: _ratingStars,
                    review: _reviewText.text);
              }
            }
          }),
          margin:
              EdgeInsets.symmetric(horizontal: rWidth(5), vertical: rWidth(5)),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _reviewFormKey,
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: rWidth(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        right: rWidth(15), top: rWidth(30), bottom: rWidth(10)),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: rWidth(10)),
                      child: Text(
                        'Review',
                        style: TextStyle(
                            fontFamily: 'Kamerik-Bold', fontSize: rWidth(30)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: rWidth(20),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                          httpHeaders: const {
                            'Connection': 'Keep-Alive',
                            'Keep-Alive': 'timeout=10,max=1000'
                          },
                          imageUrl: widget.item_details['item_image'],
                          placeholder: (context, url) => Container(
                              width: rWidth(84),
                              height: rWidth(120),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(rWidth(5)),
                                color: Colors.grey,
                              ),
                              child: const Expanded(
                                  child: Center(
                                      child: CircularProgressIndicator()))),
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
                                    child: Center(child: Icon(Icons.error))));
                          },
                          imageBuilder: (context, imageProvider) => Container(
                                width: rWidth(84),
                                height: rWidth(120),
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
                                widget.item_details['item_name'],
                                maxLines: 2,
                                style: TextStyle(
                                    fontFamily: 'Outfit', fontSize: rWidth(16)),
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
                            SizedBox(
                              height: rWidth(10),
                            ),
                            widget.item_details['option'] != null
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: rWidth(10),
                                        vertical: rWidth(5)),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          rWidth(3),
                                        ),
                                        border:
                                            Border.all(color: Colors.brown)),
                                    child: Text(
                                      widget.item_details['option'],
                                      style: TextStyle(fontFamily: 'Archivo'),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: rWidth(10),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: rWidth(10),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Your Overall Rating of the Product',
                      style: TextStyle(
                          fontFamily: 'Archivo-Regular',
                          color: Colors.grey.shade500),
                    ),
                  ),
                  SizedBox(
                    height: rWidth(10),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: RatingBar.builder(
                      minRating: 1,
                      initialRating: _initialRatingStars,
                      itemBuilder: (context, index) =>
                          const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 30,
                      onRatingUpdate: (double value) {
                        _ratingStars = value;
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    height: rWidth(10),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: rWidth(10),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Your Review of the Product',
                      style: TextStyle(
                          fontFamily: 'Archivo-Regular',
                          color: Colors.grey.shade500),
                    ),
                  ),
                  SizedBox(
                    height: rWidth(10),
                  ),
                  TextFormField(
                    controller: _reviewText,
                    validator: RequiredValidator(errorText: 'Review Required'),
                    maxLines: null,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void addReview({item_id, rating, review}) async {
    final auth = Provider.of<Auth>(context, listen: false);

    var response = await http.post(Uri.parse('$apiUrl/add-review'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${auth.userToken}'
    }, body: {
      'item_id': '$item_id',
      'rating': '$rating',
      'review': '$review',
    });
    var decode = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Alert(message: decode['message']).show();
      Navigator.pop(context);
    } else {
      Alert(message: decode['message']).show();
    }
  }

  void getUserReview() async {
    final auth = Provider.of<Auth>(context, listen: false);

    var response = await http.get(
        Uri.parse('$apiUrl/get-user-review/${widget.item_details['item_id']}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${auth.userToken}'
        });
    var decode = jsonDecode(response.body);
    if (response.statusCode == 200) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text(
                'Your Review already exists. You cannot add a new review for this product, but can edit your existing review.'),
            actions: <Widget>[
              TextButton(
                child: Text('Approve'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      _reviewText.text = decode['review']['review'];
      _initialRatingStars = decode['review']['rating'].toDouble();
      _ratingStars = decode['review']['rating'].toDouble();
      _existingReview = true;
      setState(() {});
    }
    if (response.statusCode == 404) {
    } else {
      Alert(message: decode['message']).show();
    }
  }

  void updateUserReview({item_id, rating, review}) async {
    final auth = Provider.of<Auth>(context, listen: false);

    var response =
        await http.post(Uri.parse('$apiUrl/update-user-review'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${auth.userToken}'
    }, body: {
      'item_id': '$item_id',
      'rating': '$rating',
      'review': '$review',
    });
    var decode = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Alert(message: decode['message']).show();
      Navigator.pop(context);
    } else {
      Alert(message: decode['message']).show();
    }
  }
}
