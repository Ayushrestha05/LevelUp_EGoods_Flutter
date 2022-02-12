import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:levelup_egoods/screens/login_screen.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/buttons.dart';
import 'package:levelup_egoods/widgets/form_fields.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();

  final _initialPWD = TextEditingController();

  final _finalPWD = TextEditingController();

  String? _name, _email;

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
                                maxLines: 1,
                                onSaved: (String? value) {
                                  _name = value;
                                },
                              ),
                              SizedBox(
                                height: rWidth(20),
                              ),
                              CustomTextFormField(
                                hintText: "Email",
                                onSaved: (String? value) {
                                  _email = value;
                                },
                                maxLines: 1,
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
                                  } else if (_initialPWD.text !=
                                      _finalPWD.text) {
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
                                registerValidation(context);
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

  void registerValidation(BuildContext context) async {
    if (_registerFormKey.currentState?.validate() ?? false) {
      _registerFormKey.currentState?.save();
      setState(() {
        _isProcessing = true;
      });
      int status = await Provider.of<Auth>(context, listen: false)
          .register(_name, _email, _initialPWD.text);
      if (status != null) {
        setState(() {
          _isProcessing = false;
        });
        //Alert Dialogs for carious status codes.
        switch (status) {
          case 201:
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: const Text('Registration Successful'),
                    content: const Text('You will now be redirected to home'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
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
    }
  }
}
