import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:levelup_egoods/screens/forgot_password/token_input_screen.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/buttons.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _forgotPasswordEmailFormKey = GlobalKey<FormState>();

  final TextEditingController _emailTextBox = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: _isLoading
              ? Container(
                  height: 0,
                )
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: rWidth(20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DefaultButton('Send Reset Password', () {
                        if (_forgotPasswordEmailFormKey.currentState!
                            .validate()) {
                          forgotPassword(context);
                        }
                      }),
                      SizedBox(
                        height: rWidth(10),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "You remembered your password? ",
                                style: TextStyle(
                                    fontFamily: "Outfit",
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color)),
                            const TextSpan(
                                text: "Login",
                                style: TextStyle(
                                    fontFamily: "Outfit",
                                    color: Colors.lightBlueAccent)),
                          ]),
                        ),
                      ),
                      SizedBox(
                        height: rWidth(10),
                      ),
                    ],
                  ),
                ),
          body: Stack(
            children: [
              Form(
                key: _forgotPasswordEmailFormKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: rWidth(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Reset\nPassword',
                        style: TextStyle(
                            fontFamily: 'Kamerik-Bold', fontSize: rWidth(30)),
                      ),
                      SizedBox(
                        height: rWidth(20),
                      ),
                      Text(
                        'Please enter your email address to request a password reset.',
                        style: TextStyle(
                            fontFamily: 'Archivo-Regular',
                            fontSize: rWidth(15)),
                      ),
                      SizedBox(
                        height: rWidth(20),
                      ),
                      TextFormField(
                        controller: _emailTextBox,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'An Email is Required'),
                          EmailValidator(errorText: 'Enter a Valid Email')
                        ]),
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        style: TextStyle(
                          fontFamily: 'Archivo-Regular',
                        ),
                      )
                    ],
                  ),
                ),
              ),
              _isLoading
                  ? Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(child: CircularProgressIndicator()))
                  : Container(),
            ],
          )),
    );
  }

  void forgotPassword(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    var response =
        await http.post(Uri.parse('$apiUrl/forgot-password'), headers: {
      'Accept': 'application/json',
    }, body: {
      'email': _emailTextBox.text,
    });
    var decode = jsonDecode(response.body);
    setState(() {
      _isLoading = false;
    });
    if (response.statusCode == 200) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => TokenInputScreen(
                    email: _emailTextBox.text,
                  )));
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text(decode['message']),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
