import 'dart:developer';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:application/util/app_url.dart';
import 'package:http/http.dart' as http;

import 'package:application/pages/login.dart';

class MyAppBar extends StatefulWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
          child: Text("BookTrader", style: TextStyle(color: Colors.white))),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            logout();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage()),
                (Route<dynamic> route) => false);
          },
          child: Text("خروج", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  logout() async {
    var response;
    var url = Uri.parse(AppUrl.logout);
    var token = sharedPreferences.getString("token");
    try {
      response =
          await http.get(url, headers: {'Authorization': 'Token $token'});
      sharedPreferences.clear();
      sharedPreferences.commit();
      print(response.body);
    } catch (e) {
      print(e);
    }
  }
}
