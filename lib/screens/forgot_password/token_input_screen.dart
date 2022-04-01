import 'dart:convert';

import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/forgot_password/reset_password_screen.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/OTPInput.dart';
import 'package:levelup_egoods/widgets/buttons.dart';
import 'package:http/http.dart' as http;

class TokenInputScreen extends StatefulWidget {
  final String email;

  TokenInputScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<TokenInputScreen> createState() => _TokenInputScreenState();
}

class _TokenInputScreenState extends State<TokenInputScreen> {
  final TextEditingController _fieldOne = TextEditingController();

  final TextEditingController _fieldTwo = TextEditingController();

  final TextEditingController _fieldThree = TextEditingController();

  final TextEditingController _fieldFour = TextEditingController();

  final TextEditingController _fieldFive = TextEditingController();

  final TextEditingController _fieldSix = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            bottomNavigationBar: _isLoading
                ? Container(
                    height: 0,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: rWidth(20)),
                          child: DefaultButton('Verify Token', () {
                            verifyPIN(context);
                          })),
                      SizedBox(
                        height: rWidth(20),
                      ),
                      InkWell(
                        onTap: () {
                          resendPINCode();
                        },
                        child: const Text(
                          'Resend PIN Code',
                          style: TextStyle(
                              fontFamily: 'Archivo',
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      SizedBox(
                        height: rWidth(20),
                      ),
                    ],
                  ),
            body: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Token Verification',
                        style: TextStyle(
                            fontFamily: 'Kamerik-Bold', fontSize: rWidth(20)),
                      ),
                      SizedBox(
                        height: rWidth(10),
                      ),
                      Text(
                        'Check your Email. We\'ve sent you the PIN at ${widget.email}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Archivo-Regular',
                          fontSize: rWidth(15),
                        ),
                      ),
                      SizedBox(
                        height: rWidth(20),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: rWidth(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OtpInput(_fieldOne, true),
                            OtpInput(_fieldTwo, false),
                            OtpInput(_fieldThree, false),
                            OtpInput(_fieldFour, false),
                            OtpInput(_fieldFive, false),
                            OtpInput(_fieldSix, false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _isLoading
                    ? Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Center(child: CircularProgressIndicator()))
                    : Container(),
              ],
            )));
  }

  void resendPINCode() async {
    setState(() {
      _isLoading = true;
    });
    var response =
        await http.post(Uri.parse('$apiUrl/forgot-password'), headers: {
      'Accept': 'application/json',
    }, body: {
      'email': widget.email,
    });
    setState(() {
      _isLoading = false;
    });
    var decode = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Alert(message: decode['message']).show();
    } else {
      Alert(message: decode['message']).show();
    }
  }

  void verifyPIN(BuildContext context) async {
    var response = await http.post(Uri.parse('$apiUrl/verify/pin'), headers: {
      'Accept': 'application/json',
    }, body: {
      'email': widget.email,
      'token':
          '${_fieldOne.text}${_fieldTwo.text}${_fieldThree.text}${_fieldFour.text}${_fieldFive.text}${_fieldSix.text}'
    });
    var decode = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Alert(message: decode['message']).show();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ResetPasswordScreen(
                    email: widget.email,
                  )));
    } else {
      Alert(message: decode['message']).show();
    }
  }
}
