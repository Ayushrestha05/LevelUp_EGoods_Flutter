import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/size_config.dart';

class EmailFormField extends StatelessWidget {
  const EmailFormField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Email",
        hintStyle: const TextStyle(fontFamily: 'Outfit'),
        contentPadding: EdgeInsets.only(
            top: rWidth(10), left: rWidth(16), bottom: rWidth(10)),
        border: OutlineInputBorder(
          borderSide: const BorderSide(),
          borderRadius: BorderRadius.all(Radius.circular(rWidth(10))),
        ),
      ),
    );
  }
}

class PasswordFormField extends StatefulWidget {
  PasswordFormField({
    Key? key,
  }) : super(key: key);

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure,
      decoration: InputDecoration(
        suffixIcon: IconButton(
            onPressed: () {
              obscure ? obscure = false : obscure = true;
              setState(() {});
            },
            icon: Icon(obscure ? Icons.visibility : Icons.visibility_off)),
        hintText: "Password",
        hintStyle: const TextStyle(fontFamily: 'Outfit'),
        contentPadding: EdgeInsets.only(
            top: rWidth(10), left: rWidth(16), bottom: rWidth(10)),
        border: OutlineInputBorder(
          borderSide: const BorderSide(),
          borderRadius: BorderRadius.all(Radius.circular(rWidth(10))),
        ),
      ),
    );
  }
}
