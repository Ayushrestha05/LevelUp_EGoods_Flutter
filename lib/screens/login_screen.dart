import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:levelup_egoods/screens/register_screen.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/buttons.dart';
import 'package:levelup_egoods/widgets/form_fields.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();

  String? _email, _password;

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 45,
                child: _buildLoginScreen(context),
              ),
            ),
            _isProcessing
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.5)),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF6FFFE9),
                      ),
                    ),
                  )
                : Container()
          ],
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
          Container(
            height: rWidth(241),
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
                  maxLines: 1,
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
                  loginValidation(context);
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

  void loginValidation(BuildContext context) async {
    if (_loginFormKey.currentState?.validate() ?? false) {
      //Show the Circular Progress Indicator
      setState(() {
        _isProcessing = true;
      });
      _loginFormKey.currentState?.save();
      int status = await Provider.of<Auth>(context, listen: false)
          .login(_email, _password);
      //Remove the Circular Progress Indicator
      if (status != null) {
        setState(() {
          _isProcessing = false;
        });
        //Alert Dialogs for carious status codes.
        switch (status) {
          case 200:
            Navigator.pop(context);
            break;

          case 401:
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: const Text('Invalid Credentials'),
                    content: const Text('Enter correct credentials to login.'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'))
                    ],
                  );
                });
            break;

          default:
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: const Text('Error!'),
                    content: const Text(
                        'Some Error Occured. Please try again later.'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'))
                    ],
                  );
                });
            break;
        }
      }
    } else {
      print("not validated");
    }
  }
}
