import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
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

class _CheckoutLayoutState extends State<CheckoutLayout> {
  int currentStep = 0;
  bool? hidden = false, wrapped = false, successPayment = false;
  String fullName = "", phone = "", city = "", address = "", message = "";
  final _shipmentFormKey = GlobalKey<FormState>();

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
        body: Stepper(
          type: StepperType.horizontal,
          currentStep: currentStep,
          steps: [
            Step(
                state: currentStep > 0 ? StepState.complete : StepState.indexed,
                title: Text('Shipping'),
                content: buildShipmentForm(),
                isActive: currentStep >= 0),
            Step(
                state: currentStep > 1 ? StepState.complete : StepState.indexed,
                title: Text('Summary'),
                content: buildSummary(),
                isActive: currentStep >= 1),
            Step(
                state: currentStep > 2 ? StepState.complete : StepState.indexed,
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
      ),
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
                border: OutlineInputBorder(),
                fillColor: Colors.white,
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
                border: OutlineInputBorder(),
                fillColor: Colors.white,
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
                fillColor: Colors.white,
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
                fillColor: Colors.white,
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
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              fillColor: Colors.white,
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
            KhaltiScope.of(context).pay(
              config: config,
              preferences: [PaymentPreference.khalti],
              onSuccess: (successModel) {
                // Perform Server Verification
                paymentVerification(
                    token: successModel.token,
                    amount: successModel.amount.toString(),
                    test_amount: auth.totalPrice.toString());
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
          },
          label: Text('Pay with Khalti'),
        )
      ],
    );
  }

  buildPayment() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          successPayment! ? Text('Success') : Text('Failure'),
          ElevatedButton(
            onPressed: () {
              if (successPayment!) {
                Navigator.pop(context);
              } else {
                setState(() {
                  currentStep -= 1;
                });
              }
            },
            child: successPayment! ? Text('Continue') : Text('Back'),
          )
        ],
      ),
    );
  }

  void paymentVerification(
      {required String token,
      required String amount,
      required String test_amount}) async {
    final auth = Provider.of<Auth>(context, listen: false);
    var response =
        await http.post(Uri.parse("$apiUrl/payment-verification"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${auth.userToken}',
    }, body: {
      'token': token,
      'amount': amount,
      'test_amount': test_amount,
      'recieverName': fullName,
      'recieverPhone': phone,
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
        auth.getCart();
      });
    } else {
      setState(() {
        successPayment = false;
        currentStep += 1;
      });
    }
  }
}
