// ignore_for_file: non_constant_identifier_names

import 'package:esp32test/usersettings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'led.dart';
import 'getState.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSettings.init(); //getting user settings when app Boots up!
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => UserProvider(),
        child: Consumer(builder: (context, UserProvider notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ESP32 Test',
            theme: ThemeData(brightness: Brightness.dark),
            home: HomePage(),
          );
        }));
  }
}
