import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
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
    return KhaltiScope(
      enabledDebugging: true,
      publicKey: "test_public_key_6357c62ac39a48f8afa0fb04d0b4083a",
      builder: (context, navigatorKey) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Level Up EGoods',
          theme: theme.selectedTheme == 'dark' ? dark : light,
          home: BaseScreen(),
          localizationsDelegates: const [KhaltiLocalizations.delegate],
        );
      },
    );
  }
}
