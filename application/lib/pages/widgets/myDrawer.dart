import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:application/pages/profile.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:application/util/app_url.dart';
import 'package:http/http.dart' as http;

import 'package:application/pages/login.dart';
import 'package:application/main.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  SharedPreferences sharedPreferences;

  var name;
  var lastName;
  var email;
  var picture;
  var token;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text(
                "اسم",
                style: TextStyle(),
              ),
              accountEmail: Text("ایمیل"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("م"),
              )),
          ListTile(
            title: Text("داشبور"),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => MainPage()),
                  (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            title: Text("پروفایل"),
            leading: Icon(Icons.account_box_rounded),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => ProfilePage()),
                  (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            title: Text("خروج"),
            leading: Icon(Icons.logout),
            onLongPress: () {
              logout();
              sharedPreferences.clear();
              sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  logout() async {
    var response;
    var url = Uri.parse(AppUrl.logout);
    var token = sharedPreferences.getString("token");
    try {
      response =
          await http.get(url, headers: {'Authorization': 'Token $token'});
      print(response.body);
    } catch (e) {
      print(e);
    }
  }
}
