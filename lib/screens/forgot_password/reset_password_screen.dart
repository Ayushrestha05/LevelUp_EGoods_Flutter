import 'dart:convert';

import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/buttons.dart';
import 'package:levelup_egoods/widgets/form_fields.dart';
import 'package:http/http.dart' as http;

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _resetPasswordEmailFormKey = GlobalKey<FormState>();

  final _initialPWD = TextEditingController();

  final _finalPWD = TextEditingController();

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
                  margin: EdgeInsets.symmetric(
                      horizontal: rWidth(20), vertical: rWidth(20)),
                  child: DefaultButton('Save Password', () {
                    if (_resetPasswordEmailFormKey.currentState!.validate()) {
                      resetPassword(context);
                    }
                  })),
          body: Stack(
            children: [
              Form(
                  key: _resetPasswordEmailFormKey,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: rWidth(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create new Password',
                          style: TextStyle(
                              fontFamily: 'Kamerik-Bold', fontSize: rWidth(20)),
                        ),
                        SizedBox(
                          height: rWidth(20),
                        ),
                        Text(
                          'New Password',
                          style: TextStyle(fontFamily: 'Archivo'),
                        ),
                        SizedBox(
                          height: rWidth(5),
                        ),
                        CustomRePasswordFormField(
                          controller: _initialPWD,
                          hintText: "",
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "Please Enter a Value"),
                            MinLengthValidator(8,
                                errorText:
                                    'Password must be at least 8 characters long'),
                            PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                                errorText:
                                    'Passwords must have at least one special character')
                          ]),
                        ),
                        SizedBox(
                          height: rWidth(20),
                        ),
                        Text(
                          'Re-enter the new password',
                          style: TextStyle(fontFamily: 'Archivo'),
                        ),
                        SizedBox(
                          height: rWidth(5),
                        ),
                        CustomRePasswordFormField(
                          hintText: "",
                          controller: _finalPWD,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter a value";
                            } else if (_initialPWD.text != _finalPWD.text) {
                              return "Passwords do not match";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  )),
              _isLoading
                  ? Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(child: CircularProgressIndicator()))
                  : Container(),
            ],
          )),
    );
  }

  void resetPassword(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    var response =
        await http.post(Uri.parse('$apiUrl/reset-password'), headers: {
      'Accept': 'application/json',
    }, body: {
      'email': widget.email,
      'password': '${_initialPWD.text}'
    });
    setState(() {
      _isLoading = false;
    });
    var decode = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
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
    } else {
      Alert(message: decode['message']).show();
    }
  }
}
