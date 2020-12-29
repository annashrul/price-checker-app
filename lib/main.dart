import 'package:asset_cache/asset_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:price_checker_app/auth_screen.dart';
import 'package:price_checker_app/config.dart';
import 'package:price_checker_app/helper_widget.dart';
import 'package:price_checker_app/repository.dart';
import 'package:price_checker_app/scan_screen.dart';
import 'package:price_checker_app/tenant_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database/config_database.dart';

void main() {
  ByteDataAssets.instance.basePath = 'assets/img/';
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

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
      home:SplashScreen()
    );
  }
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final DatabaseConfig _db = new DatabaseConfig();

  Widget child;
  final GlobalKey<ScaffoldState> navigatorKey = new GlobalKey<ScaffoldState>();
  Future checkRoute()async{
    final repo = Repository();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("timer",10);
    final token  = await repo.getDataUser("token");
    final tenant  = prefs.getString("tenant");
    final lokasi  = prefs.getString("kode_lokasi");

    print("TOKEN $token");
    print("TENANT $tenant");
    print("LOKASI $lokasi");
    if(tenant==null&&lokasi==null){
      WidgetHelper().myPushRemove(context, TenantScreen());
    }
    if(tenant!=null&&lokasi==null){
      WidgetHelper().myPushRemove(context, AuthScreen());
    }
    if(tenant!=null&&lokasi!=null){
      WidgetHelper().myPushRemove(context, ScanScreen());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkRoute();
    _db.openDB();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<ByteData>(
              future: ByteDataAssets.instance.load('ic_logo.png'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: MemoryImage(snapshot.data.buffer.asUint8List()),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter
                        )
                    ),
                  );
                  // return Image.memory(snapshot.data.buffer.asUint8List());
                } else {
                  return Text('loading..');
                }
              },
            ),
            
            Align(
              alignment: Alignment.bottomCenter,
              child: WidgetHelper().loadingWidget(context),
            )
          ],
        ),
      ),
    );
  }
}

