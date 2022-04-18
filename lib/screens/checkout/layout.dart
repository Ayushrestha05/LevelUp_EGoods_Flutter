import 'dart:convert';

import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:levelup_egoods/utilities/ClipShadowPath.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CheckoutLayout extends StatefulWidget {
  const CheckoutLayout({Key? key}) : super(key: key);

  @override
  State<CheckoutLayout> createState() => _CheckoutLayoutState();
}

class _CheckoutLayoutState extends State<CheckoutLayout>
    with SingleTickerProviderStateMixin {
  int currentStep = 0;
  int discountPercent = 0;
  double amount_required = 0;
  bool? hidden = false, wrapped = false, successPayment = false;
  bool _isProcessing = false;
  String fullName = "",
      phone = "",
      city = "",
      address = "",
      message = "",
      email = "";
  final _shipmentFormKey = GlobalKey<FormState>();
  late AnimationController _controller;

  void getCheckoutSale() async {
    var response = await http.get(Uri.parse('$apiUrl/get-checkout-sale'));
    if (response.statusCode == 200) {
      var decode = jsonDecode(response.body);
      if (decode.length > 0) {
        discountPercent = decode['discount_percent'];
        amount_required = decode['amount_required'].toDouble();
      }
    }
  }

  @override
  void initState() {
    getCheckoutSale();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Checkout',
              style: TextStyle(fontFamily: 'Archivo'),
            ),
          ),
          body: Stack(
            children: [
              Stepper(
                onStepTapped: (value) {
                  setState(() {
                    currentStep = value;
                  });
                },
                type: StepperType.horizontal,
                currentStep: currentStep,
                steps: [
                  Step(
                      state: currentStep > 0
                          ? StepState.complete
                          : StepState.indexed,
                      title: Text('Shipping'),
                      content: buildShipmentForm(),
                      isActive: currentStep >= 0),
                  Step(
                      state: currentStep > 1
                          ? StepState.complete
                          : StepState.indexed,
                      title: Text('Summary'),
                      content: buildSummary(),
                      isActive: currentStep >= 1),
                  Step(
                      state: currentStep > 2
                          ? StepState.complete
                          : StepState.indexed,
                      title: Text('Payment'),
                      content: buildPayment(),
                      isActive: currentStep >= 2),
                ],
                onStepContinue: () {
                  setState(() {
                    if (currentStep < 2) {
                      if (currentStep == 0) {
                        if (_shipmentFormKey.currentState!.validate()) {
                          _shipmentFormKey.currentState!.save();
                          currentStep += 1;
                        }
                      } else {
                        currentStep += 1;
                      }
                    }
                  });
                },
                onStepCancel: () {
                  setState(() {
                    if (currentStep > 0) {
                      currentStep -= 1;
                    }
                  });
                },
                controlsBuilder: (context, controlDetails) {
                  if (currentStep == 2) {
                    return Container();
                  } else {
                    return Row(
                      children: [
                        currentStep == 1
                            ? Container()
                            : Expanded(
                                child: ElevatedButton(
                                  onPressed: controlDetails.onStepContinue,
                                  child: const Text('Next'),
                                ),
                              ),
                        currentStep != 0
                            ? Expanded(
                                child: ElevatedButton(
                                  onPressed: controlDetails.onStepCancel,
                                  child: Text('Back'),
                                ),
                              )
                            : Container(),
                      ],
                    );
                  }
                },
              ),
              _isProcessing
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF6FFFE9).withOpacity(0.5),
                        ),
                      ),
                    )
                  : Container()
            ],
          )),
    );
  }

  buildShipmentForm() {
    const TextStyle formHeading = TextStyle(fontFamily: 'Archivo');

    return Form(
      key: _shipmentFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Full name',
            style: formHeading,
          ),
          SizedBox(
            height: rWidth(7),
          ),
          TextFormField(
            onSaved: (value) {
              fullName = value!;
            },
            validator: RequiredValidator(errorText: 'Enter a name'),
            decoration: InputDecoration(
                hintText: 'Full Name Here',
                border: OutlineInputBorder(),
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                    vertical: rWidth(5), horizontal: rWidth(10))),
          ),
          SizedBox(
            height: rWidth(10),
          ),
          const Text(
            'Phone number',
            style: formHeading,
          ),
          SizedBox(
            height: rWidth(7),
          ),
          TextFormField(
            onSaved: (value) {
              phone = value!;
            },
            keyboardType: TextInputType.phone,
            maxLength: 10,
            validator: MultiValidator([
              RequiredValidator(
                  errorText: 'Enter a phone which can be contacted'),
            ]),
            decoration: InputDecoration(
                hintText: 'Phone Number Here',
                border: OutlineInputBorder(),
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                    vertical: rWidth(5), horizontal: rWidth(10))),
          ),
          const Text(
            'Email',
            style: formHeading,
          ),
          SizedBox(
            height: rWidth(7),
          ),
          TextFormField(
            onSaved: (value) {
              email = value!;
            },
            keyboardType: TextInputType.emailAddress,
            validator: MultiValidator([
              RequiredValidator(
                  errorText: 'Enter an email to send digital codes to.'),
            ]),
            decoration: InputDecoration(
                hintText: 'Email Address Here',
                border: OutlineInputBorder(),
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                    vertical: rWidth(5), horizontal: rWidth(10))),
          ),
          SizedBox(
            height: rWidth(10),
          ),
          const Text(
            'Address',
            style: formHeading,
          ),
          SizedBox(
            height: rWidth(7),
          ),
          TextFormField(
            onSaved: (value) {
              city = value!;
            },
            validator: RequiredValidator(errorText: 'Enter a City'),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                filled: true,
                hintText: 'City',
                contentPadding: EdgeInsets.symmetric(
                    vertical: rWidth(5), horizontal: rWidth(10))),
          ),
          SizedBox(
            height: rWidth(7),
          ),
          TextFormField(
            onSaved: (value) {
              address = value!;
            },
            validator: RequiredValidator(errorText: 'Enter an Address'),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                filled: true,
                hintText: 'Address',
                contentPadding: EdgeInsets.symmetric(
                    vertical: rWidth(5), horizontal: rWidth(10))),
          ),
          SizedBox(
            height: rWidth(10),
          ),
          const Divider(
            thickness: 2,
          ),
          SizedBox(
            height: rWidth(10),
          ),
          const Text(
            'Delivery Instructions',
            style: formHeading,
          ),
          SizedBox(
            height: rWidth(7),
          ),
          CheckboxListTile(
            title: Text(
              'Non-Transparent Bag',
              style: formHeading,
            ),
            value: hidden,
            onChanged: (value) {
              setState(() {
                hidden = value;
              });
            },
          ),
          CheckboxListTile(
            title: Text(
              'Gift Wrapped',
              style: formHeading,
            ),
            value: wrapped,
            onChanged: (value) {
              setState(() {
                wrapped = value;
              });
            },
          ),
          SizedBox(
            height: rWidth(10),
          ),
          const Text(
            'Message to be attached with (optional)',
            style: formHeading,
          ),
          SizedBox(
            height: rWidth(7),
          ),
          TextFormField(
            onSaved: (value) {
              message = value!;
            },
            maxLines: null,
            maxLength: 255,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              filled: true,
            ),
          ),
        ],
      ),
    );
  }

  buildSummary() {
    const TextStyle summaryStyle = TextStyle(fontFamily: 'Archivo-Regular');
    final auth = Provider.of<Auth>(context, listen: false);
    final String orderIdentity =
        '${auth.userName}-Order-${DateFormat('yyyy-MM-dd-hh-mm-ss').format(DateTime.now())}';
    final config = PaymentConfig(
      //amount: auth.totalPrice.toInt() * 100,
      amount: 1000,
      productIdentity: orderIdentity,
      productName: orderIdentity,
      additionalData: {
        'vendor': 'Level Up E-Goods Store',
      },
    );
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: rWidth(15), vertical: rWidth(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Shipping To:',
                      style: summaryStyle,
                    ),
                    SizedBox(
                      height: rWidth(5),
                    ),
                    Text(fullName,
                        style: const TextStyle(fontFamily: 'Archivo')),
                    SizedBox(
                      height: rWidth(5),
                    ),
                    Text(address, style: summaryStyle),
                    Text(city, style: summaryStyle),
                    SizedBox(
                      height: rWidth(5),
                    ),
                    Text(phone, style: summaryStyle),
                  ],
                ),
              ),
              Divider(
                thickness: 2,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: rWidth(15), vertical: rWidth(10)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('Subtotal', style: summaryStyle),
                        const Spacer(),
                        Text(
                          auth.totalPrice.toString(),
                          style: const TextStyle(fontFamily: 'Archivo'),
                        ),
                        SizedBox(
                          width: rWidth(3),
                        ),
                        const Text(
                          'NPR',
                          style: TextStyle(fontFamily: 'Archivo'),
                        )
                      ],
                    ),
                    auth.totalPrice > amount_required && discountPercent != 0
                        ? Row(
                            children: [
                              Text('Discount ($discountPercent%)',
                                  style: summaryStyle),
                              const Spacer(),
                              Text(
                                (auth.totalPrice * (discountPercent / 100))
                                    .toString(),
                                style: const TextStyle(fontFamily: 'Archivo'),
                              ),
                              SizedBox(
                                width: rWidth(3),
                              ),
                              const Text(
                                'NPR',
                                style: TextStyle(fontFamily: 'Archivo'),
                              )
                            ],
                          )
                        : Container(),
                    Row(
                      children: [
                        Text('Total', style: summaryStyle),
                        const Spacer(),
                        auth.totalPrice > amount_required
                            ? Text(
                                (auth.totalPrice -
                                        (auth.totalPrice *
                                            (discountPercent / 100)))
                                    .toString(),
                                style: const TextStyle(fontFamily: 'Archivo'),
                              )
                            : Text(
                                auth.totalPrice.toString(),
                                style: const TextStyle(fontFamily: 'Archivo'),
                              ),
                        SizedBox(
                          width: rWidth(3),
                        ),
                        const Text(
                          'NPR',
                          style: TextStyle(fontFamily: 'Archivo'),
                        )
                      ],
                    ),
                    SizedBox(
                      height: rWidth(5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: rWidth(10),
        ),
        ElevatedButton.icon(
          icon: Container(
            margin: EdgeInsets.symmetric(vertical: rWidth(10)),
            height: rWidth(30),
            child: Image.asset(
              'assets/images/khalti_logo.png',
            ),
          ),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xFF4F276E))),
          onPressed: () {
            setState(() {
              _isProcessing = true;
            });
            KhaltiScope.of(context).pay(
              config: config,
              preferences: [PaymentPreference.khalti],
              onSuccess: (successModel) {
                // Perform Server Verification
                paymentVerification(
                  token: successModel.token,
                  amount: successModel.amount.toString(),
                  test_amount: auth.totalPrice.toString(),
                  discount_percentage: discountPercent.toString(),
                  total_amount: discountPercent == 0
                      ? auth.totalPrice.toString()
                      : (auth.totalPrice -
                              (auth.totalPrice * (discountPercent / 100)))
                          .toString(),
                  discount_amount: discountPercent == 0
                      ? "0"
                      : (auth.totalPrice * (discountPercent / 100)).toString(),
                );
              },
              onFailure: (failureModel) {
                // What to do on failure?
                setState(() {
                  currentStep += 1;
                });
              },
              onCancel: () {
                // User manually cancelled the transaction
                Alert(message: 'User cancelled the Payment').show();
              },
            );
            setState(() {
              _isProcessing = false;
            });
          },
          label: Text('Pay with Khalti'),
        )
      ],
    );
  }

  buildPayment() {
    const TextStyle summaryStyle = TextStyle(fontFamily: 'Archivo-Regular');
    final auth = Provider.of<Auth>(context, listen: false);

    return SizeTransition(
      sizeFactor: _controller,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipShadowPath(
              shadow: Shadow(
                blurRadius: 1,
              ),
              clipper: MultipleRoundedCurveClipper(),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white, boxShadow: [BoxShadow()]),
                padding: EdgeInsets.symmetric(
                    vertical: rWidth(30), horizontal: rWidth(15)),
                //height: 100,
                //width: 200,

                child: Column(
                  children: [
                    CircleAvatar(
                      foregroundColor: Colors.white,
                      backgroundColor: successPayment!
                          ? Color(0xFF63C0DF)
                          : Color(0xFFCF000F),
                      radius: 20,
                      child: successPayment!
                          ? Icon(Icons.check)
                          : Icon(Icons.close),
                    ),
                    SizedBox(
                      height: rWidth(10),
                    ),
                    successPayment!
                        ? const Text(
                            'Your Purchase was successful!',
                            style: TextStyle(fontFamily: 'Archivo'),
                          )
                        : const Text(
                            'Your Purchase failed!',
                            style: TextStyle(fontFamily: 'Archivo'),
                          ),
                    SizedBox(
                      height: rWidth(20),
                    ),
                    successPayment!
                        ? Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Summary',
                              style: TextStyle(fontFamily: 'Archivo'),
                            ),
                          )
                        : Container(),
                    successPayment!
                        ? const Divider(
                            thickness: 2,
                          )
                        : Container(),
                    successPayment!
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  const Text('Subtotal', style: summaryStyle),
                                  const Spacer(),
                                  Text(
                                    auth.totalPrice.toString(),
                                    style:
                                        const TextStyle(fontFamily: 'Archivo'),
                                  ),
                                  SizedBox(
                                    width: rWidth(3),
                                  ),
                                  const Text(
                                    'NPR',
                                    style: TextStyle(fontFamily: 'Archivo'),
                                  )
                                ],
                              ),
                              auth.totalPrice > amount_required &&
                                      discountPercent != 0
                                  ? Row(
                                      children: [
                                        Text('Discount ($discountPercent%)',
                                            style: summaryStyle),
                                        const Spacer(),
                                        Text(
                                          (auth.totalPrice *
                                                  (discountPercent / 100))
                                              .toString(),
                                          style: const TextStyle(
                                              fontFamily: 'Archivo'),
                                        ),
                                        SizedBox(
                                          width: rWidth(3),
                                        ),
                                        const Text(
                                          'NPR',
                                          style:
                                              TextStyle(fontFamily: 'Archivo'),
                                        )
                                      ],
                                    )
                                  : Container(),
                              Row(
                                children: [
                                  Text('Total', style: summaryStyle),
                                  const Spacer(),
                                  auth.totalPrice > amount_required
                                      ? Text(
                                          (auth.totalPrice -
                                                  (auth.totalPrice *
                                                      (discountPercent / 100)))
                                              .toString(),
                                          style: const TextStyle(
                                              fontFamily: 'Archivo'),
                                        )
                                      : Text(
                                          auth.totalPrice.toString(),
                                          style: const TextStyle(
                                              fontFamily: 'Archivo'),
                                        ),
                                  SizedBox(
                                    width: rWidth(3),
                                  ),
                                  const Text(
                                    'NPR',
                                    style: TextStyle(fontFamily: 'Archivo'),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: rWidth(5),
                              ),
                            ],
                          )
                        : Container(),
                    SizedBox(
                      height: rWidth(20),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          if (successPayment!) {
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              currentStep -= 1;
                            });
                          }
                        },
                        child:
                            successPayment! ? Text('Continue') : Text('Back'),
                      ),
                    ),
                    SizedBox(
                      height: rWidth(20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void paymentVerification({
    required String token,
    required String amount,
    required String test_amount,
    required String discount_amount,
    required String discount_percentage,
    required String total_amount,
  }) async {
    final auth = Provider.of<Auth>(context, listen: false);

    var response =
        await http.post(Uri.parse("$apiUrl/payment-verification"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${auth.userToken}',
    }, body: {
      'token': token,
      'amount': amount,
      'sub_total': test_amount,
      'discount_percentage': discount_percentage,
      'discount_amount': discount_amount,
      'total': total_amount,
      'recieverName': fullName,
      'recieverPhone': phone,
      'recieverEmail': email,
      'recieverCity': city,
      'recieverAddress': address,
      'senderMessage': message,
      'nonTransparentBag': hidden! ? "1" : "0",
      'giftWrap': wrapped! ? "1" : "0",
    });
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        successPayment = true;
        currentStep += 1;
        auth.getUserPoints();
        auth.getCart();
      });

      _controller.reset();
      _controller.forward();
    } else {
      setState(() {
        successPayment = false;
        currentStep += 1;
      });
    }
  }
}
