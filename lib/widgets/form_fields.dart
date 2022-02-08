import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/size_config.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  const CustomTextFormField({
    Key? key,
    required this.hintText,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        hintText: hintText,
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

class CustomPasswordFormField extends StatefulWidget {
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  const CustomPasswordFormField({
    Key? key,
    required this.validator,
    this.onSaved,
  }) : super(key: key);

  @override
  State<CustomPasswordFormField> createState() =>
      _CustomPasswordFormFieldState();
}

class _CustomPasswordFormFieldState extends State<CustomPasswordFormField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      onSaved: widget.onSaved,
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

class CustomRePasswordFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const CustomRePasswordFormField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hintText,
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
