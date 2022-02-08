import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:levelup_egoods/screens/register_screen.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/buttons.dart';
import 'package:levelup_egoods/widgets/form_fields.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final _loginFormKey = GlobalKey<FormState>();
  String? _email, _password;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 45,
            child: _buildLoginScreen(context),
          ),
        ),
      ),
    );
  }

  _buildLoginScreen(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Image.asset(
              'assets/images/login_header.jpg',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: rWidth(20), right: rWidth(20), top: rWidth(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                      fontFamily: "Outfit",
                      fontSize: rWidth(32),
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: rWidth(30),
                ),
                CustomTextFormField(
                  hintText: "Email",
                  onSaved: (String? value) {
                    _email = value;
                  },
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Please Enter a Value"),
                    EmailValidator(errorText: "Please Enter a valid Email"),
                  ]),
                ),
                SizedBox(
                  height: rWidth(20),
                ),
                CustomPasswordFormField(
                  validator:
                      RequiredValidator(errorText: "Please Enter a Value"),
                  onSaved: (String? value) {
                    _password = value;
                  },
                ),
                SizedBox(
                  height: rWidth(20),
                ),
                DefaultButton("Sign In", () {
                  loginValidation();
                }),
                SizedBox(
                  height: rWidth(10),
                ),
                const Text(
                  "Forgot Password",
                  style: TextStyle(fontFamily: "Outfit"),
                ),
                SizedBox(
                  height: rWidth(15),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => RegisterScreen()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                                fontFamily: "Outfit",
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color)),
                        const TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                                fontFamily: "Outfit",
                                color: Colors.lightBlueAccent)),
                      ]),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void loginValidation() {
    if (_loginFormKey.currentState?.validate() ?? false) {
      _loginFormKey.currentState?.save();
      Auth().login(_email, _password);
    } else {
      print("not validated");
    }
  }
}
