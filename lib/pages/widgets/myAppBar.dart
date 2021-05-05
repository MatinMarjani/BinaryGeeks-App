import 'dart:developer';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:application/util/app_url.dart';
import 'package:http/http.dart' as http;

import 'package:application/pages/login.dart';
import 'package:application/pages/searchPage.dart';

class MyAppBar extends StatefulWidget {
  static Widget appBarTitle =
      Text("BookTrader", style: TextStyle(color: Colors.white, fontFamily: 'myfont'));
  static Icon actionIcon = Icon(Icons.search, color: Colors.white);

  @override
  _MyAppBarState createState() => _MyAppBarState(appBarTitle, actionIcon);
}

class _MyAppBarState extends State<MyAppBar> {
  SharedPreferences sharedPreferences;
  Widget appBarTitle =
      Text("BookTrader", style: TextStyle(color: Colors.white, fontFamily: 'myfont'));
  Icon actionIcon = Icon(Icons.search, color: Colors.white);


  _MyAppBarState(
    this.appBarTitle,
    this.actionIcon,
  );

  @override
  void initState() {
    super.initState();
    // init();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: appBarTitle,
      actions: <Widget>[
        IconButton(
          icon: actionIcon,
          onPressed: () {
            if (this.actionIcon.icon == Icons.search) {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => SearchPage()));
            } else {
              setState(() {
                this.actionIcon = Icon(
                  Icons.search,
                  color: Colors.white,
                );
                this.appBarTitle =
                    Text("BookTrader", style: TextStyle(color: Colors.white, fontFamily: 'myfont'));
                Navigator.pop(context);
                // _searchQuery.clear();
              });
            }
          },
        ),
      ],
    );
  }
}
