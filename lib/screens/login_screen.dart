import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/buttons.dart';
import 'package:levelup_egoods/widgets/form_fields.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: Form(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.blue,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: rWidth(20), vertical: rWidth(30)),
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
                    const EmailFormField(),
                    SizedBox(
                      height: rWidth(20),
                    ),
                    PasswordFormField(),
                    SizedBox(
                      height: rWidth(20),
                    ),
                    DefaultButton(),
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
                    Container(
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
}
