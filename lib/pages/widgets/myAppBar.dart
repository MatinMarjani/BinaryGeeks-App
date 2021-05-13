import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:application/pages/searchPage.dart';

import 'package:application/util/Utilities.dart';

class MyAppBar extends StatefulWidget {
  final Color mainColor = Utilities().mainColor;
  final String myFont = Utilities().myFont;

  static Widget appBarTitle =
      Text("BookTrader", style: TextStyle(color: Colors.white, fontFamily: Utilities().myFont));
  static Icon actionIcon = Icon(Icons.search, color: Colors.white);

  @override
  _MyAppBarState createState() => _MyAppBarState(appBarTitle, actionIcon);
}

class _MyAppBarState extends State<MyAppBar> {
  SharedPreferences sharedPreferences;
  Widget appBarTitle =
      Text("BookTrader", style: TextStyle(color: Colors.white, fontFamily: Utilities().myFont));
  Icon actionIcon = Icon(Icons.search, color: Colors.white);


  _MyAppBarState(
    this.appBarTitle,
    this.actionIcon,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: appBarTitle,
      backgroundColor: widget.mainColor,
      actions: <Widget>[
        IconButton(
          icon: actionIcon,
          onPressed: () {
            if (this.actionIcon.icon == Icons.search) {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => SearchPage()));
            } else if (this.actionIcon.icon == Icons.close ){
              setState(() {
                this.actionIcon = Icon(
                  Icons.search,
                  color: Colors.white,
                );
                this.appBarTitle =
                    Text("BookTrader", style: TextStyle(color: Colors.white, fontFamily: Utilities().myFont));
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
