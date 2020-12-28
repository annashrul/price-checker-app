import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:price_checker_app/config.dart';
import 'package:price_checker_app/tenant_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarIconBrightness: Brightness.dark, statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: Constant().fontStyle,
        primaryColor: Constant().mainColor,
        brightness: Brightness.light,
      ),
      home:  TenantScreen(),
    );
  }
}

