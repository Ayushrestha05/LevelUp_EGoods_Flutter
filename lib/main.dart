import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:levelup_egoods/screens/base_screen.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/models/theme.dart';
import 'package:levelup_egoods/utilities/theme_data.dart';
import 'package:provider/provider.dart';

late String token;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

//Recieve message when app is in background
Future<void> backgroundHandler(RemoteMessage message) async {
  //print(message.data.toString());
}

void main() async {
  //Initializing Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  FirebaseMessaging.instance.subscribeToTopic("all");
  token = (await FirebaseMessaging.instance.getToken())!;
  print("Token: $token");

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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      // print("On Select Notification");
      // print(payload);
      var decode = jsonDecode(payload!);
      // print(decode);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print("Get Initial Message");
      if (message != null) {}
    });

    //Foreground
    FirebaseMessaging.onMessage.listen((message) {
      flutterLocalNotificationsPlugin.show(
        message.notification.hashCode,
        message.notification!.title,
        message.notification!.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'high_importance_channel', 'High Importance Notifications',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              color: Colors.blue,
              icon: '@mipmap/ic_launcher'),
        ),
        payload: jsonEncode(message.data),
      );
    });

    //Background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("On Message Opened");
      print(message.data.toString());
    });
  }

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
