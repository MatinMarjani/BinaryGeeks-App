import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:application/pages/login.dart';
import 'package:application/pages/dashboard.dart';


import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:application/pages/widgets/myAppBar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "",
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('fa', ''), // Farsi, no country code
      ],
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(accentColor: Colors.white70),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    setState(() {
      MyAppBar.appBarTitle =
          Text("BookTrader", style: TextStyle(color: Colors.white));
      MyAppBar.actionIcon = Icon(Icons.search, color: Colors.white);
    });
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashBoard();
  }
}
