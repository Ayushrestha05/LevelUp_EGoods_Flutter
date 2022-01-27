import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:levelup_egoods/screens/login_screen.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/buttons.dart';
import 'package:levelup_egoods/widgets/form_fields.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  final _registerFormKey = GlobalKey<FormState>();
  final _initialPWD = TextEditingController();
  final _finalPWD = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            //height: MediaQuery.of(context).size.height,
            child: Form(
              key: _registerFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: rWidth(130),
                    child: Image.asset(
                      'assets/images/register_header.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: rWidth(20), vertical: rWidth(24)),
                    child: Center(
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
                          CustomTextFormField(
                            hintText: "Full Name",
                            validator: RequiredValidator(
                                errorText: "Please enter a value"),
                          ),
                          SizedBox(
                            height: rWidth(20),
                          ),
                          CustomTextFormField(
                            hintText: "Email",
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: "Please Enter a Value"),
                              EmailValidator(
                                  errorText: "Please Enter a valid Email")
                            ]),
                          ),
                          SizedBox(
                            height: rWidth(20),
                          ),
                          CustomRePasswordFormField(
                            controller: _initialPWD,
                            hintText: "Password",
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
                          CustomRePasswordFormField(
                            controller: _finalPWD,
                            hintText: "Re-Enter Password",
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
                          SizedBox(
                            height: rWidth(20),
                          ),
                          DefaultButton("Sign Up", () {
                            _registerFormKey.currentState?.validate();
                          }),
                          SizedBox(
                            height: rWidth(20),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => LoginScreen()));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: RichText(
                                text: TextSpan(
                                  children: [
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
