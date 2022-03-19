import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:levelup_egoods/screens/base_screen.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/models/theme.dart';
import 'package:levelup_egoods/utilities/theme_data.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (BuildContext context) => Auth(),
      ),
      ChangeNotifierProvider<AppTheme>(
        create: (BuildContext context) => AppTheme(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppTheme>(context);
    //Setting the App to Portrait Only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Level Up EGoods',
      theme: theme.selectedThemeData,
      home: BaseScreen(),
    );
  }
}
