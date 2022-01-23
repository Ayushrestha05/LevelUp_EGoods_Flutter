import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/login_screen.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/buttons.dart';
import 'package:levelup_egoods/widgets/form_fields.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 50,
            child: _buildRegisterScreen(context),
          ),
        ),
      ),
    );
  }

  _buildRegisterScreen(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Image.asset(
              'assets/images/register_header.png',
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
                  "Register",
                  style: TextStyle(
                      fontFamily: "Outfit",
                      fontSize: rWidth(32),
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: rWidth(15),
                ),
                const CustomTextFormField(hintText: "Full Name"),
                SizedBox(
                  height: rWidth(20),
                ),
                const CustomTextFormField(hintText: "Email"),
                SizedBox(
                  height: rWidth(20),
                ),
                const CustomRePasswordFormField(
                  hintText: "Password",
                ),
                SizedBox(
                  height: rWidth(20),
                ),
                const CustomRePasswordFormField(
                  hintText: "Re-Enter Password",
                ),
                SizedBox(
                  height: rWidth(20),
                ),
                DefaultButton("Sign Up"),
                SizedBox(
                  height: rWidth(20),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => LoginScreen()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                                fontFamily: "Outfit",
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color)),
                        const TextSpan(
                            text: "Sign In",
                            style: TextStyle(
                                fontFamily: "Outfit",
                                color: Colors.lightBlueAccent)),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
