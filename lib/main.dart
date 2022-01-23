import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/login_screen.dart';
import 'package:levelup_egoods/utilities/theme_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: dark,
      home: const LoginScreen(),
    );
  }
}
